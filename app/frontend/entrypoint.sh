#!/bin/sh
# entrypoint.sh: Template Nginx config with env vars and start Nginx
set -e

: "${BACKEND_URL:=http://backend:3000}"

# Substitute env var in backend.conf.template to default.conf
envsubst '$BACKEND_URL' < /tmp/backend.conf.template > /etc/nginx/conf.d/default.conf
# Remove the template file to avoid confusion
rm -rf /tmp/backend.conf.template

exec nginx -g 'daemon off;'