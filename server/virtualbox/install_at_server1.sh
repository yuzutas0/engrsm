#!/bin/bash

# ================================
# environment variables
# ================================

APP_NAME=engrsm
HOST_NAME=staging.${APP_NAME}.com
RUBY_VERSION=2.3.3
LINUX_USER=vagrant

# ================================
# execute scripts
# ================================

sudo bash -x ./scripts/02_packages.sh
sudo DOMAIN_NAME=${HOST_NAME} ADMIN_EMAIL=${EMAIL} bash -x ./scripts/03_postfix.sh
sudo ROOT_PASSWORD=${DB_ROOT_PASSWORD} USER=${APP_NAME} PASSWORD=${DB_PASSWORD} SCHEME=${APP_NAME} bash -x ./scripts/04_mariadb.sh
sudo bash -x ./scripts/05_redis.sh
sudo APP=${APP_NAME} HOST=${HOST_NAME} bash -x ./scripts/06_elasticsearch.sh
VERSION=${RUBY_VERSION} bash -x ./scripts/07_ruby.sh
USER=${LINUX_USER} bash -x ./scripts/08_ready-for-app.sh
sudo APP=${APP_NAME} HOST=${HOST_NAME} bash -x ./scripts/09_nginx.sh
