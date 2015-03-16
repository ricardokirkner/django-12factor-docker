.DEFAULT_GOAL := help

help:
	@echo "help      -- print this help"
	@echo "start     -- start the app"

start:
	@python manage.py syncdb --noinput
	@python manage.py migrate --noinput
	@python manage.py collectstatic --noinput
	@foreman start
