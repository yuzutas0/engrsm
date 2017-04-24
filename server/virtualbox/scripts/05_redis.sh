#!/bin/bash

yum install -y epel-release
yum --enablerepo=epel install -y redis

systemctl start redis
systemctl enable redis

redis-cli ping
