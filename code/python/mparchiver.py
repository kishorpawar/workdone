import ConfigParser, io, sys, MySQLdb, os
import time
from _mysql_exceptions import MySQLError

def main(argv=None):
    if argv == None:
        argv = sys.argv
    try:
        path = argv[1]
    except IndexError:
        print "Try again with config file."
        sys.exit()
        
    config = ConfigParser.RawConfigParser(allow_no_value=True)
    try:
        config.readfp(open(path))
    except IOError:
        print "Please check if file exists or path given is right."
        
    
    try:   
        storage = config.get("storage", "location")
        shost = config.get("source", "host")
        sdb = config.get("source", "database")
        stb = config.get("source", "table")
        susr = config.get("source", "username")
        spwd = config.get("source", "password")
#         if storage == "dest":
        dhost = config.get("dest", "host")
        ddb = config.get("dest", "database")
        dtb = config.get("dest", "table")
        dusr = config.get("dest", "username")
        dpwd = config.get("dest", "password")
    except Exception as e:
        print e
    
    source_con = MySQLdb.connect(host=shost, user=susr, passwd=spwd, db=sdb)
    source_cursor = source_con.cursor()
    if storage=="dest":
        dest_con = MySQLdb.connect(host=dhost, user=dusr, passwd=dpwd, db=ddb)
        dest_cursor = dest_con.cursor()
    
    if storage == "file":
        outfile = "/tmp/%s_mp_raw_data.txt"% time.strftime("%y%m%d") # cloud location where file need to be stored.
    else:
        outfile = "/tmp/%s_mp_raw_data.txt"% time.strftime("%y%m%d")
        
    select_query = """
                    select * from %s 
                    where date(event_time)<date(subdate(now(),62))
                    into outfile '%s';
                   """% (stb, outfile)
    select_max_query = """
                        select max(id) from %s 
                        where date(event_time)<=date(subdate(now(),62))
                       """ % stb
    
    delete_query ="""
                    delete from %s
                    where id < id_val                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
                  """ % stb
    load_query = """
                  load data infile '%s' into table %s;
                 """% (outfile , dtb)
    
    """
    
    """             
    def delete_old(load_result):
        try:
            source_cursor.execute(select_max_query)
            result = source_cursor.fetchall()
            print "Wait... deleting data"
            if load_result:
                if os.path.exists(outfile):
                    os.remove(outfile)
                query = delete_query.replace("id_val", str(result[0][0]))
                source_cursor.execute(query)
                source_con.commit()
                source_con.close()
        except MySQLError as e:
            print e
    
    if storage == "rm":
        load_result =1 
        delete_old(load_result)
    else:
        try:
            if os.path.exists(outfile):
                os.remove(outfile)
                
#             source_cursor = source_con.cursor()
            print "Wait... retrieving data"
            select_result = source_cursor.execute(select_query)
        except MySQLError as e:
            print e
        
    if storage == "dest":
        try:
#             dest_cursor = dest_con.cursor()
            print "Wait... importing data"
            load_result = dest_cursor.execute(load_query)
            dest_con.commit()
            dest_con.close()
            delete_old(load_result)
        except MySQLError as e:
            print e
            
    if storage == "file":
        load_result = 1
        delete_old(load_result)

if __name__ == "__main__":
    sys.exit(main())