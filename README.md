django-12factor-docker
======================

Sample django project demonstrating the 12-factor architecture using docker.

Quickstart
----------

To start the sample application run

$ make up

This will rebuild any containers that have been updated and will then
start the full stack.

To stop the sample application run

$ make stop

For other possible targets run

$ make help

Stack
-----

Currently the stack consists of 3 containers:

- db: a postgresql database
- app: a simple django application
- web: a frontend web server based on nginx

The only container exposed to the host is the 'web' container,
simulating a production environment where all other parts are
protected by a firewall or DMZ.
