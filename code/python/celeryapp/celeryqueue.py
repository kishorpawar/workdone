import os
from celery import Celery


os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'ossite.settings')
app = Celery('ossite.celeryapp.tasks', backend='amqp', broker='amqp://')

app.config_from_object('ossite.celeryapp.celeryconf')
