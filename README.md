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

First you need to start the sentry container so that you can
generate the credentials required for the app to be able to
send error reports to it.

$ make up SERVICE=sentry

Once the service is up, log into http://localhost:9000 using the default admin credentials
for the sentry server:

- username: admin
- password: admin

Create a default organization, team and project, and let it generate an api
key for our Django project. With that key, create a file *conf/app.env* with the contents:

RAVEN_DSN=http://<key>:<secret>@sentry:9000/<id>

Now it’s time to start the stack. Just run

$ make up

This will rebuild any containers that have been updated and will then
start the full stack.

To verify sentry is properly working with the provided credentials, you
can submit a test message to sentry like

$ docker-compose run app python manage.py raven test

And then verify it shows up in http://localhost:9000

To stop the stack run

$ make down

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
- sentryworker: celery workers for processing sentry events
- sentryredis: redis backend for caching and celery tasks for sentry
- sentryredisdata: a data volume container for the sentryredis container
- sentrydb: a postgresql database for sentry
- sentrydbdata: a data volume container for the sentrydb container
- elk: a full ELK stack (elasticsearch/logstash/kibana)
- logstashforwarder: a container running logstash-forwarder to process logs from other containers

The only containers exposed on the host are:
- web: to access the application as it’s intended in production,
- flower: to access the admin console for the rabbitmq server
- sentry: to view the logs and errors
- elk: to view logs via kibana and to inspect elasticsearch (for easier debugging)

Limiting the services accessible from the host is intended to
simulate a production environment where all other parts are
protected by a firewall or DMZ.
