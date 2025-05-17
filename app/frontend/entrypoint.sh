#!/bin/sh
# entrypoint.sh: Template Nginx config with env vars and start Nginx
set -e

: "${BACKEND_URL:=http://backend:3000}"

# Substitute env var in server.conf.template to default.conf
envsubst '$BACKEND_URL' < /etc/nginx/server.conf.template > /etc/nginx/conf.d/default.conf

exec nginx -g 'daemon off;'
