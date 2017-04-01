"""created by Kishor Pawar
14th June 2013
Contains all the view related to user login.

"""

from django.shortcuts import render_to_response
from django import http
from django.contrib import auth
from django.contrib.auth.forms import AuthenticationForm
from django.template import Context
from django.template.loader import render_to_string
from django.contrib.auth.decorators import login_required
from django.contrib.auth.models import Group
from matchpoint import constants, settings
from gps.utils.permissions import is_logged_in
from gps import models
import pytz
from django.core.exceptions import ObjectDoesNotExist




class Block():
    """its kind of interface, extended by LoginBlock."""
    _template = None  # template for this block
    context = Context()  # dict containing context variables value for this template
    
    def __str__(self):
        self.render()
    
    def set_template(self, template):
        """ set templates """
        self._template = template
        
    def set_extra_context(self, extra_context):
        """ sets extra context for template """
        self.context.update(extra_context)
        
    def render(self):
        """ render to string """
        return render_to_string(self._template, context_instance=self.context)
    
    def render_to_response(self):
        """ render to response """
        return render_to_response(self._template, self.context)
    

class LoginBlock(Block):
    
    """extends Block."""
    
    authentication_form = None

    def __init__(self, request):
        self.non_form_errors = ""
        self.authentication_form = AuthenticationForm(request, initial=
                                      {'username':"Username", 'password':"Password"})
        self.context['form'] = self.authentication_form
        
    def login(self, request):
        
        """authenticates User."""
        
        username = request.POST.get('username', '')
        password = request.POST.get('password', '')
        remember = request.POST.get("remember")
        if username != '' and password != '':
            user = auth.authenticate(username=username, password=password)
            if user is not None and user.is_active:
                # Correct password, and the user is marked active
                auth.login(request, user)
                try:
                    user_timezone = models.UserProfile.objects.get(user=user).timezone
                except ObjectDoesNotExist:
                    user_timezone = settings.TIME_ZONE
                
                request.session['user_timezone'] = pytz.timezone(user_timezone)
                if remember:
                    request.session.set_expiry(constants.SESSION_AGE)
                return landing(request)
            else:
                self.non_form_errors = "Invalid username or password"
                self.context['non_form_errors'] = self.non_form_errors
                return False
        
    def get_error(self):
        """returns non form errors."""
        return self.non_form_errors

def landing(request):
    """This function defines the landing pages for the various types of users.
    
    """
    user = request.user
    
    if request.GET.has_key('next'):
        return http.HttpResponseRedirect(request.GET['next'])
    
    if is_logged_in(user):
        if user is not None and \
            (user.groups.filter(name=constants.INDIVIDUAL) or user.is_superuser):
            return http.HttpResponseRedirect(constants.INDIVIDUAL_LANDING)
        
        elif user is not None and user.groups.filter(name=constants.CALLCENTER):
            return http.HttpResponseRedirect(constants.CC_USER_LANDING)
        
        elif user is not None and user.groups.filter(name=constants.MATCHPOINTADMIN):
            return http.HttpResponseRedirect(constants.MPADMIN_LANDING)
        
        elif user is not None and user.groups.filter(name=constants.ENTERPRISE):
            return http.HttpResponseRedirect(constants.ENTERPRISE_LANDING)
    else:
        group = Group.objects.get(name=constants.LOGGED_IN)
        user.groups.add(group)
        return http.HttpResponseRedirect("/change/")


def home(request):
    
    """directs to login page.
    
    """
    login = LoginBlock( request )

    login.set_template( "login.html" )
    login.set_extra_context( { 'form_title':"Login", "non_form_errors":"" } )
    if request.method == "POST":
        response = login.login(request )
        if response:
            return response

    return render_to_response( 'login.html', { 'form':login.context['form'],
                            'non_form_errors':login.context['non_form_errors']} )

@login_required
def logout( request ):
    
    """Calls django's logout function to log out user."""
    
    auth.logout(request)
    return http.HttpResponseRedirect( '/' )

@login_required
def pasword_change(request):
    """Redirects to home page."""
    if request.user.is_authenticated():
        return http.HttpResponseRedirect("/gps/")

