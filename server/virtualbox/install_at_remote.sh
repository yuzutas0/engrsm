#!/bin/bash

bash -x ./scripts/02_packages.sh

bash -x ./scripts/03_postfix.sh DOMAIN_NAME=staging.engrsm.com ADMIN_EMAIL=${EMAIL}

# TODO: postfix
# TODO: mariadb or mysql
# TODO: redis
# TODO: elasticsearch
# TODO: ruby
# TODO: rails
# TODO: nginx
# TODO: let's encrypt
# TODO: logrotate
