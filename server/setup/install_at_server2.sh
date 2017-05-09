#!/bin/bash

# execute after ./install_at_deploy.sh

# ================================
# environment variables
# ================================

APP_NAME=engrsm
HOST_NAME=staging.${APP_NAME}.com
LINUX_USER=vagrant

# ================================
# execute scripts
# ================================

sudo USER=${LINUX_USER} APP=${APP_NAME} HOST=${HOST_NAME} bash -x ./scripts/10_lets-encript.sh
sudo USER=${LINUX_USER} APP=${APP_NAME} bash -x ./scripts/11_start-app.sh
sudo USER=${LINUX_USER} APP=${APP_NAME} bash -x ./scripts/12_logrotate.sh
