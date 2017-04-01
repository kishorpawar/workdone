from ossite.utils import constants as const
from ossite import settings as settings
from ossite.celeryapp.celeryqueue import app 
from ossite.media_storage.errors import FileNotFound, TransferError
from ossite.media_storage.manage import MediaStorage
from ossite.omnisign import models
from ossite.omnisign.utils import constants
from ossite.omnisign.scripts.transfer_logs import main
from ossite.diskspace import diskspace
#from ossite.channel.cron import ChannelData

import logging
import os
import subprocess
import sys
import datetime

from django.db.models import Q
from django.core.exceptions import ObjectDoesNotExist, MultipleObjectsReturned
 
preview_log = logging.getLogger( const.PREVIEW_TRANSCODING_LOGGER )
thumbnail_log = logging.getLogger( const.THUMBNAIL_TRANSCODING_LOGGER )
transfer_log = logging.getLogger( const.TRANSFER_LOGGER )
delete_log = logging.getLogger( const.LOCAL_MEDIA_DELETION_LOGGER )
   
@app.task(name='start_transfer',bind=True)
def start_transfer(self, mid, mtype, local_path ):
    cloud_files = MediaStorage()
    transfer_log.info("Connected to Cloud Files")
    is_transfering = False

    try:
        if not is_transfering and constants.USE_CLOUD_FILES:
            start_time = datetime.datetime.now()
            try:
                if mtype == \
                    constants.PLAYER_TRANSFER_QUEUE_NAME:

                    st_transfer = datetime.datetime.now()
                    cloud_files \
                    .store_player_media_object( local_path )
                    is_transfering = True
                    transfer_log.info("Transferring original %s to cloud "% local_path)

                elif mtype == \
                    constants.THUMBNAIL_QUEUE_NAME:
                    
                    st_transfer = datetime.datetime.now()
                    cloud_files \
                    .store_thumbnail_media_object( local_path )

                    is_transfering = True
                    transfer_log.info("Transferring Thumbnail %s to cloud "% local_path)

                elif mtype == \
                    constants.PREVIEW_QUEUE_NAME:

                    st_transfer = datetime.datetime.now()
                    cloud_files \
                    .store_preview_media_object( local_path )

                    is_transfering = True
                    transfer_log.info("Transferring preview %s to cloud "% local_path)
                else:
                    raise FileNotFound( "No file to transfer." )

            except FileNotFound as exp:
                transfer_log.info( "File Not Found....%s" % ( 
                                    exp, ) )
                is_transfering = False
                raise self.retry(exc=exp)
            except TransferError as exp:
                transfer_log.info( "Transfer Error....%s\n%s" % ( 
                                    sys.exc_info(), exp)) 
                is_transfering = False
                raise self.retry(exc=exp)
            except Exception as exp:
                transfer_log.info( "Unknown Error....%s\n%s" % ( 
                                    sys.exc_info(),exp ) ) 
                is_transfering = False
                raise self.retry(exc=exp)
            else:
                transfer_log.info( "Upload time: %s" % ( 
                                    get_end_time( st_transfer ) ))
                 
                __set_media_transfer_flag(mid,mtype)
                __delete()

                transfer_log.info( "%s transfer completed." % ( 
                                  mtype, )) 
                transfer_log.info( "Total time: %s" % ( 
                                    get_end_time( start_time ) )) 
        
    except Exception as exp:
        transfer_log.info( "Unexcepted Error....%s" % ( 
                            sys.exc_info(), ) )
        raise self.retry(exc=exp)
        


@app.task(name='process_transcoding',bind=True)
def process_transcoding(self, mid, inputfile, outputfile, transcode ):
    try:
        
        if transcode == constants.TOTHUMBNAIL:
            args  = __getThumbnailerCommand(inputfile, outputfile)
            mtype = constants.THUMBNAIL_QUEUE_NAME
        elif transcode == constants.TOPREVIEW:
            args = __getWebPreviewCommand( inputfile, outputfile )
            mtype = constants.PREVIEW_QUEUE_NAME
        
        if subprocess.check_call(args)==0:
            thumbnail_log.info( "%s transcoded and saved to %s" %(inputfile, 
                                                                   outputfile))
            if constants.USE_CLOUD_FILES:
                start_transfer.apply_async(args=[mid, mtype, outputfile])

    except IOError as ioe:
        thumbnail_log.info( "IOError: %s" % ( ioe, )) 
        raise self.retry(exc=ioe)
    except ValueError as ver:
        thumbnail_log.info( "Value Error: %s" % ( ver, ))
        raise self.retry(exc=ver) 
    except OSError as ose:
        thumbnail_log.info( "OSError: %s" % ( ose, ))
        raise self.retry(exc=ose) 
    except Exception as exp:
        thumbnail_log.info( "Unexpected error: %s" % ( exp, ))
        raise self.retry(exc=exp) 

@app.task(name='transfer_logs',bind=True)
def transfer_logs():
    print "transferring logs."
    m = main()
    m.set_max_id()
    m.get_max_id()
    m.delete_duplicates()
    m.fetch_logs()
    m.update_transfer()
    m.upload_logs()
    print "Logs transfer completed."

@app.task(name='convert_to_pdf',bind=True)
def convert_to_pdf(self, mid, inputfile, outputfile ):
    args = ["/usr/bin/unoconv", '-f', 'pdf', inputfile]
    try:
        subprocess.Popen( args, stdout = subprocess.PIPE ).stdout
    except Exception as e:
        print e
    else:
        if constants.USE_CLOUD_FILES:
            mtype = constants.PLAYER_TRANSFER_QUEUE_NAME
            start_transfer.apply_async(args=[mid, mtype, outputfile])

        


# @app.task(name="channel_job")
# def channel_job():
#     print "Running Channel server."
#     chan = ChannelData()
#     chan.job()
    
def __set_media_transfer_flag(mid, mtype):
    try:
        media = models.OS_Media.objects.get( id = mid )
    except (ObjectDoesNotExist, MultipleObjectsReturned):
        pass
    else:
        if mtype == constants.PLAYER_TRANSFER_QUEUE_NAME:
            media.player_media_transfer = True
            transfer_log.info("Setting original media transfer flag for %s"
                                %media.name)
        elif mtype == constants.THUMBNAIL_QUEUE_NAME:
            media.thumbnail_transfer = True
            transfer_log.info("Setting thumbnail media transfer flag for %s"
                                %media.name)
        elif mtype == constants.PREVIEW_QUEUE_NAME:
            media.preview_transfer = True
            transfer_log.info("Setting preview media transfer flag for %s"
                                %media.name)
        media.save()


def __getThumbnailerCommand(inputfile, outputfile ):

    ffmpegthumbnailer = ["/usr/bin/ffmpegthumbnailer", "-i"]
    return ffmpegthumbnailer + [inputfile] + ["-o"] + [outputfile]

def __getWebPreviewCommand(inputfile, outputfile):
    if settings.IS_INNOWORTH:
        ffmpeg = ["/home/omnisign/bin/ffmpeg", "-i"]
    else:
        ffmpeg = ["/usr/bin/avconv", "-i"]
        
    return ffmpeg + [inputfile] + ["-y"] + ["-s"] + ["640x480"] + [outputfile]


def __delete():
    medialist = models.OS_Media.objects \
                    .filter( player_media_transfer = True ) \
                    .filter( thumbnail_transfer = True ) \
                    .filter( Q(preview_transfer = True) | 
                             Q(type__name = const.IMAGE_TYPE))

    for media in medialist:
        delete_log.info( "Processing media....%s for deletion" 
                                                % ( media.name, ) )

        basename = os.path.splitext( media.name )[0]

        thumb_loc = "%s%s%s" % ( constants.THUMBNAIL_LOCATIONS, basename,
                                 constants.THUMBNAIL_EXT )
        preview_loc = "%s%s%s" % ( constants.PREVIEW_LOCATIONS, basename,
                                 constants.WEB_PREVIEW_EXT )
        media_loc = "%s%s" % ( settings.MEDIA_ROOT,
                               media.original_media_uri )

        __delete_medialist( [thumb_loc, preview_loc, media_loc] )

def __delete_medialist( paths ):
    for path in paths:
        delete_log.info( "Trying to delete path %s if present." 
                                                        % ( path, ) )
        __delete_media( path )

def __delete_media( path ):
    try:
        if os.path.exists( path ) and os.path.isfile( path ):
            os.remove( path )
            delete_log.info( "File Deleted....%s" % ( path, ) )
    except NameError as ( errno, strerror ):
        delete_log.error( 
            "Name error({0}): {1}".format( errno, strerror ) )
    except Exception as e:
        print "in except", e
        delete_log.error( 
                "Error while removing media....%s" % ( sys.exc_info() ) )


def get_end_time( start_time ):
    if isinstance( start_time, datetime.datetime ):
        tdate = datetime.datetime.now() - start_time
        return ( tdate.microseconds +
                 ( tdate.seconds + tdate.days * 24 * 3600 ) * 10 ** 6 ) / 10 ** 6
    else:
        return 0
    
#check diskspace usage of server. If lower than threshold, sends email to superuser of ossite.    
@app.task(name = 'watch_diskspace_usage', bind = True)
def watch_diskspace_usage():
    diskspace.check_disk_usage()