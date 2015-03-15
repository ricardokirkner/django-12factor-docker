.DEFAULT_GOAL := help

help:
	@echo "help      -- print this help"
	@echo "build     -- build docker environment"
	@echo "up        -- start docker stack"
	@echo "down      -- stop docker stack"
	@echo "env       -- create a virtualenv"
	@echo "clean     -- clean all artifacts"

env: env/bin/activate

.PHONY: build
build: .build

.PHONY: up
up: build
	@. env/bin/activate; docker-compose up

.PHONY: down
down:
	@. env/bin/activate; docker-compose stop

.PHONY: clean
clean: clean-docker clean-env
	@rm -f .build

# helpers

env/bin/activate: build-requirements.txt
	@test -d env || virtualenv env
	@. env/bin/activate; pip install -r build-requirements.txt
	@touch env/bin/activate

.build: env docker-compose.yml
	@. env/bin/activate; docker-compose build
	@touch .build

.PHONY: clean-docker
clean-docker:
	@. env/bin/activate; docker-compose rm --force

.PHONY: clean-env
clean-env:
	@rm -rf env

.PHONY: .env
.env:
	@echo "DATABASE_URL=postgres://docker:docker@${DB_1_PORT_5432_TCP_ADDR}:${DB_1_PORT_5432_TCP_PORT}/docker" > .env
	@echo "BROKER_URL=amqp://guest:guest@${AMQP_1_PORT_5672_TCP_ADDR}:${AMQP_1_PORT_5672_TCP_PORT}/" >> .env
	@echo "DEBUG=True" >> .env
	@echo "C_FORCE_ROOT=1" >> .env

start: .env
	@python manage.py syncdb --noinput
	@python manage.py migrate --noinput
	@python manage.py collectstatic --noinput
	@foreman start

superuser:
	@docker-compose run app python /usr/src/app/manage.py createsuperuser
