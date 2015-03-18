django-12factor-docker
======================

Sample django project demonstrating the 12-factor architecture using docker.

Configuration
-------------

Some basic configuration needs to be in place before the whole environment can
be properly started.

Configuration files are located in the *conf* folder, and they should contain
one environment variable definition per line, using the syntax *KEY=VALUE*.

- conf/app.env

This file should contain the following:

    RAVEN_DSN=http://apikey:password@sentry:9000/2

To obtain the values for *apikey* and *apipassword* first start the stack once,
log into sentry, and configure the service appropriately. Sentry will generate
a key/password pair that should then be entered into this config file and the
stack restarted to allow the app to send error reports to sentry.

- conf/sentry.env

This file should contain the following:

    SECRET_KEY=changeme

Change the value as you see fit.


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

Currently the stack consists of:

- db: a postgresql database
- dbdata: a data volume container for the db container
- app: a simple django application
- web: a frontend web server based on nginx
- amqp: a rabbitmq server to queue celery tasks
- amqpdata: a data volume container for the amqp container
- flower: a web application for monitoring and administering the rabbitmq server
- sentry: a modern error logging and aggregation platform

The only containers exposed on the host are:
- web: to access the application as it’s intended in production,
- flower: to access the admin console for the rabbitmq server
- sentry: to view the logs and errors

Limiting the services accessible from the host is intended to
simulate a production environment where all other parts are
protected by a firewall or DMZ.
