#!/bin/bash

APP_NAME=engrsm
RUBY_VERSION=2.3.3
LINUX_USER=vagrant
LINUX_PASSWORD=${LINUX_USER}
STAGING_SERVER=192.168.33.10
MAIL_HOST=staging.engrsm.com
SSH_PORT=22
REDIS_NUMBER=1

# install for Linux
sudo bash -x ./scripts/02_packages.sh
VERSION=${RUBY_VERSION} bash -x ./scripts/07_ruby.sh
USER=${LINUX_USER} bash -x ./scripts/08_ready-for-app.sh

sudo yum install -y libsass

# install for Rails
cd /home/${LINUX_USER}/${APP_NAME}

bundle install --without production --path vendor/bundle
bundle exec rake bower:install
bundle exec rake emoji

# connect staging server
echo "*** password: ${LINUX_PASSWORD}"
ssh ${LINUX_USER}@${STAGING_SERVER} 'echo "success connect!"'

# settings for staging server
KEY_BASE=$(bundle exec rake secret)
cp .env_template .env

sed -i -e "/HOST_URL=/c HOST_URL=${MAIL_HOST}" .env
sed -i -e "/LOCAL_USER=/c LOCAL_USER=${LINUX_USER}" .env

sed -i -e "/DB_SCHEMA=/c DB_SCHEMA=${APP_NAME}" .env
sed -i -e "/DB_USERNAME=/c DB_USERNAME=${APP_NAME}" .env
sed -i -e "/DB_PASSWORD=/c DB_PASSWORD=${DB_PASSWORD}" .env
sed -i -e "/REDIS_DB=/c REDIS_DB=${REDIS_NUMBER}" .env

sed -i -e "/SERVER_IP=/c SERVER_IP=${STAGING_SERVER}" .env
sed -i -e "/OS_USER=/c OS_USER=${LINUX_USER}" .env
sed -i -e "/SSH_PORT=/c SSH_PORT=${SSH_PORT}" .env
sed -i -e "/SSH_PASSWORD=/c SSH_PASSWORD=${LINUX_PASSWORD}" .env

sed -i -e "/RAILS_ENV=/c RAILS_ENV=production" .env
sed -i -e "/SECRET_KEY_BASE=/c SECRET_KEY_BASE=${KEY_BASE}" .env

# build & deploy
bundle exec cap production deploy # make directory -- raise error
scp .env ${LINUX_USER}@${STAGING_SERVER}:/var/www/${APP_NAME}/shared/
bundle exec cap production deploy # install apps -- raise error
# TODO: unicorn
# TODO: jenkins
