#!/bin/bash

#sudo bash -x ./scripts/02_packages.sh

sudo DOMAIN_NAME=staging.engrsm.com ADMIN_EMAIL=${EMAIL} bash -x ./scripts/03_postfix.sh

# TODO: mariadb or mysql
# TODO: redis
# TODO: elasticsearch
# TODO: ruby
# TODO: rails
# TODO: nginx
# TODO: let's encrypt
# TODO: logrotate
