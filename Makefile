.DEFAULT_GOAL := help

help:
	@echo "help      -- print this help"
	@echo "build     -- build fig environment"
	@echo "up        -- start fig stack"
	@echo "down      -- stop fig stack"
	@echo "env       -- create a virtualenv"
	@echo "clean     -- clean all artifacts"

env: env/bin/activate

.PHONY: build
build: .build

.PHONY: up
up: build
# need to sleep a bit to ensure container is fully up
# so that environment variables are properly populated
	@. env/bin/activate; fig up -d db; sleep 1
	@. env/bin/activate; fig up -d app; sleep 1
	@. env/bin/activate; fig up -d web

.PHONY: down
down:
	@. env/bin/activate; fig stop

.PHONY: clean
clean: clean-fig clean-env
	@rm -f .build

# helpers

env/bin/activate: build-requirements.txt
	@test -d env || virtualenv env
	@. env/bin/activate; pip install -r build-requirements.txt
	@touch env/bin/activate

.build: env fig.yml Dockerfile requirements.txt
	@. env/bin/activate; fig build
	@touch .build

.PHONY: clean-fig
clean-fig:
	@. env/bin/activate; fig rm --force

.PHONY: clean-env
clean-env:
	@rm -rf env

.PHONY: .env
.env:
	@echo "DATABASE_URL=postgres://docker:docker@${DB_1_PORT_5432_TCP_ADDR}:${DB_1_PORT_5432_TCP_PORT}/docker\n\
	DEBUG=True\
	"> .env

start: .env
	@python manage.py syncdb --noinput
	@python manage.py collectstatic --noinput
	@foreman start

