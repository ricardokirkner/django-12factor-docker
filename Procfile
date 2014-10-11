web: gunicorn -b 0.0.0.0:8000 project.wsgi:application
celery: celery -A project worker -l info
