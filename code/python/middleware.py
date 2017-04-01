"""created by Kishor Pawar
14th June 2013
It just add timezone to session and every request.

"""

from django.utils import timezone


class TimezoneMiddleware(object):
    
    def process_request(self, request):
        user_timezone = request.POST.get('user_timezone')
        if not user_timezone:
            user_timezone = request.session.get('user_timezone')
        if user_timezone:
            timezone.activate(user_timezone)
