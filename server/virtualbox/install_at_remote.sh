#!/bin/bash

APP_NAME=engrsm

#sudo bash -x ./scripts/02_packages.sh
#sudo DOMAIN_NAME=staging.${APP_NAME}.com ADMIN_EMAIL=${EMAIL} bash -x ./scripts/03_postfix.sh
sudo ROOT_PASSWORD=${DB_ROOT_PASSWORD} USER=${APP_NAME} PASSWORD=${DB_PASSWORD} bash -x ./scripts/04_mariadb.sh

# TODO: mariadb or mysql
# TODO: redis
# TODO: elasticsearch
# TODO: ruby
# TODO: rails
# TODO: nginx
# TODO: let's encrypt
# TODO: logrotate
