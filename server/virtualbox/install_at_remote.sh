#!/bin/bash

APP_NAME=engrsm
HOST_NAME=staging.${APP_NAME}.com
RUBY_VERSION=2.3.3

#sudo bash -x ./scripts/02_packages.sh
#sudo DOMAIN_NAME=${HOST_NAME} ADMIN_EMAIL=${EMAIL} bash -x ./scripts/03_postfix.sh
#sudo ROOT_PASSWORD=${DB_ROOT_PASSWORD} USER=${APP_NAME} PASSWORD=${DB_PASSWORD} bash -x ./scripts/04_mariadb.sh
#sudo bash -x ./scripts/05_redis.sh
#sudo APP=${APP_NAME} HOST=${HOST_NAME} bash -x ./scripts/06_elasticsearch.sh
VERSION=${RUBY_VERSION} bash -x ./scripts/07_ruby.sh

# TODO: rails
# TODO: nginx
# TODO: let's encrypt
# TODO: logrotate
