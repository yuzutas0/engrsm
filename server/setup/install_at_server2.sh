#!/bin/bash

# execute after ./install_at_deploy.sh

sudo USER=${LINUX_USER} APP=${APP_NAME} HOST=${HOST_NAME} bash -x ./scripts/10_lets-encript.sh
sudo USER=${LINUX_USER} APP=${APP_NAME} bash -x ./scripts/11_start-app.sh
sudo USER=${LINUX_USER} APP=${APP_NAME} bash -x ./scripts/12_logrotate.sh
