"""created by Kishor Pawar
16th Dec 2013
defining interface that allows classes to send notifications via sms.
"""
from matchpoint import constants
# from gps import missed
from gps import models
import httplib
import datetime

class sms_provider( object ):

    def send_text_message(self, country_code, mobile_number, message):
        raise NotImplementedError
            
    def get_delivery_status(self):
        raise NotImplementedError
    
    def get_credits_available(self):
        raise NotImplementedError

class mvaayoo(sms_provider):
    
    def send_text_message(self, country_code, mobile_number, message):
        url = "/mvaayooapi/MessageCompose?" 
        url = url + "user=" +constants.MSG_USERNAME+ ":" + constants.MSG_PASSWORD
        url = url + "&senderID=" + constants.MSG_SENDER_ID + "&receipientno="  
        url = url + country_code+mobile_number + "&dcs=0&msgtxt=" + message +"&state=4"
        conn = httplib.HTTPConnection(constants.MSG_API_URL)
        conn.request("GET", url)

        submitted_date = datetime.datetime.utcnow()
        r1 = conn.getresponse()
        response = r1.read()
        conn.close()
        self.get_delivery_status(response, mobile_number, message, submitted_date)
        
    def get_delivery_status(self, response, caller_number, message, submitted_date):
        response = response.split(",")
        tid = response[1].strip()
        trans = models.SubmittedSms.objects \
        .create(
                transactionID = tid 
        )
        trans.save()
        sent_sms = models.NotificationsSent.objects \
        .create(
                senderID = "TRKGPS",
                recepient = caller_number,
                message = message,
                transactionID = tid,
                submittedDateTime = submitted_date,
                status = "S",
        )
        sent_sms.save()
    
    def get_credits_available(self):
        pass

class ttechno(sms_provider):
    
    def send_text_message(self, country_code, mobile_number, message):
        url = "/API/WebSMS/Http/v1.0a/index.php?" 
        url = url + "username=username&password=welcome123&sender=TRKGPS&"
        url = url + "to=" + country_code+mobile_number + "&message=" + message 
        url = url + "&reqid=1&format=json&route_id=&callback=&unique=0" 
        conn = httplib.HTTPConnection(constants.TTECHNO_MSG_API_URL)
        conn.request("GET", url)
        r1 = conn.getresponse()
        response = r1.read()
        conn.close()
        return response
    
    def get_credits_available(self):
        pass
    
    def get_delivery_status(self):
        pass

class gupshup(sms_provider):
    pass

    
class sms(object):
    
    def __init__(self, provider, country_code, mobile_number, message):
        
        self.provider = provider
        self.country = country_code
        self.mobile = mobile_number
        self.msg = message
        
        self.sms_provider = None
        if (self.provider == 'mvaayoo'):
            self.sms_provider = mvaayoo()
        elif (self.provider == 'ttechno'):
            self.sms_provider = ttechno()
        elif(self.provider == 'gupshup'):
            sms_provider = gupshup()
        
    def send_message(self):
        self.sms_provider \
                .send_text_message(self.country, self.mobile, self.msg)

