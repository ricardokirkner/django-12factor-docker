.DEFAULT_GOAL := help

help:
	@echo "help      -- print this help"
	@echo "build     -- build fig environment"
	@echo "start     -- start fig environment"
	@echo "env       -- create a virtualenv"
	@echo "clean     -- clean all artifacts"
	@echo "clean-env -- clean virtualenv"

env: env/bin/activate

.PHONY: build
build: .build

.PHONY: start
start: build
	@. env/bin/activate; fig up

.PHONY: clean-env
clean-env:
	@rm -rf env

.PHONY: clean
clean: clean-env
	@rm -f .build

# helpers

env/bin/activate: build-requirements.txt
	@test -d env || virtualenv env
	@. env/bin/activate; pip install -r build-requirements.txt
	@touch env/bin/activate

.build: env fig.yml Dockerfile requirements.txt
	@. env/bin/activate; fig build
	@touch .build
