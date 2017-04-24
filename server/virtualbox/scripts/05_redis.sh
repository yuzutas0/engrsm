#!/bin/bash

# ================================
# install
# ================================

yum install -y epel-release
yum --enablerepo=epel install -y redis

# ================================
# setup
# ================================

systemctl start redis
systemctl enable redis

# ================================
# test
# ================================

redis-cli ping
