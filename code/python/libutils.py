"""created by Kishor Pawar
18th June 2013

This contains common functions that are user in overall project.

"""

from dateutil import parser
import pytz

def toutc(dateobj, timezone):
    """This function converts naive datetime to utc timestamp."""
    fmtdate = parser.parse(dateobj) # string to datetime object
    user_tz = pytz.timezone(timezone) # getting user's timezone
    localize_date_with_tz = user_tz.localize(fmtdate) #adding user's timezone to datetime object
    utcdate = pytz.utc.normalize(localize_date_with_tz) #converting user's datetime to utc datetime
    return utcdate

def tolocal(dateobj, timezone):
    """This function converts utc timestamp to timezone specified timestamp."""
    
    utc_date_with_tz = pytz.utc.localize(dateobj) # 
    user_tz = pytz.timezone(timezone)
    localdate = user_tz.normalize(utc_date_with_tz) 
           
    return localdate