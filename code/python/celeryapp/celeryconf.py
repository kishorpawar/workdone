from datetime import timedelta

from celery.schedules import crontab

TRANSFER_LOGS = False

CELERYBEAT_SCHEDULE = {
    # Example: Run the add task every 30 seconds.
    'add-every-30-seconds': {
        'task': 'add',
        'schedule': timedelta(seconds=30),
        'args': (16, 16)
    },
    
    # Executes every Monday morning at 7:30 A.M
    'add-every-monday-morning': {
        'task': 'add',
        'schedule': crontab(hour=7, minute=30, day_of_week=1),
        'args': (16, 16),
    },
                       
    'add-everyday': {
        'task': 'watch_diskspace_usage',
        'schedule': crontab(minute=0, hour=0),
    },
    
                       
}

if TRANSFER_LOGS:
    CELERYBEAT_SCHEDULE.update(
        {    'send_logs':{
                'task':'transfer_logs',
                'schedule':crontab(minute='*/30'),
             }   
        }
     )
CELERY_TIMEZONE = 'UTC'
