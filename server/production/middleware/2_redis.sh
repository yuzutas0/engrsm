#!/bin/bash

# -----------------------
# install
# -----------------------

su

yum --enablerepo=epel install -y redis # for ec2

systemctl start redis
systemctl enable redis

systemctl status redis
# check: active

redis-cli -p 6379
# > ping
# check: PONG
