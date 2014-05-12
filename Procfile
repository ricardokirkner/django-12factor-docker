web: python manage.py run_gunicorn -b 0.0.0.0:8000
celery: celery -A project worker -l info
flower: flower --port=5555 --broker=${BROKER_URL}
