#!/bin/bash

APP_NAME=engrsm
RUBY_VERSION=2.3.3
LINUX_USER=vagrant
SSH_PORT=2222
REDIS_NUMBER=1

# install for Linux
sudo bash -x ./scripts/02_packages.sh
VERSION=${RUBY_VERSION} bash -x ./scripts/07_ruby.sh
APP=${APP_NAME} USER=${LINUX_USER} bash -x ./scripts/08_ready-for-app.sh

# TODO: Libsass

# install for Rails
cd /home/${LINUX_USER}
bundle install --path vendor/bundle --without test development --frozen
bundle exec rake bower:install
bundle exec rake emoji

# settings for staging server
KEY_BASE=$(bundle exec rake secret)
cp .env_template .env

sed -i -e "s/DB_SCHEMA=/DB_SCHEMA=${APP_NAME}/g" .env
sed -i -e "s/DB_USERNAME=/DB_USERNAME=${APP_NAME}/g" .env
sed -i -e "s/DB_PASSWORD=/DB_PASSWORD=${DB_PASSWORD}/g" .env
sed -i -e "s/REDIS_DB=/REDIS_DB=${REDIS_NUMBER}/g" .env

sed -i -e "s/SERVER_IP=/SERVER_IP=${TODO!!!}/g" .env # TODO
sed -i -e "s/OS_USER=/OS_USER=${LINUX_USER}/g" .env
sed -i -e "s/SSH_PORT=/SSH_PORT=${SSH_PORT}/g" .env
sed -i -e "s/RSA_FILE_NAME=/RSA_FILE_NAME=${TODO!!!}/g" .env # TODO

sed -i -e "s/RAILS_ENV=/RAILS_ENV=production/g" .env
sed -i -e "s/SECRET_KEY_BASE=/SECRET_KEY_BASE=${KEY_BASE}/g" .env

# TODO: build & deploy app -- capistrano
