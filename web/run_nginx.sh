#!/usr/bin/env bash

set -e

echo "Enabling config for example server with expanded environment variables"
cp /etc/nginx/sites-available/example /etc/nginx/sites-enabled/example
sed -i -e "s/GUNICORN_TCP_ADDR/$APP_1_PORT_8000_TCP_ADDR/g" /etc/nginx/sites-enabled/example
sed -i -e "s/GUNICORN_TCP_PORT/$APP_1_PORT_8000_TCP_PORT/g" /etc/nginx/sites-enabled/example

echo "Starting nginx"
nginx
