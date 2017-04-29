#!/bin/bash

# ================================
# bundler
# ================================

rbenv exec gem install bundler
rbenv rehash
bundle -v

# ================================
# nmp & bower
# ================================

sudo yum install -y epel-release
sudo yum --enablerepo=epel install -y nodejs
sudo yum --enablerepo=epel install -y npm
sudo npm install -g bower
bower -v

# ================================
# ready for app
# ================================

sudo yum install -y mysql-devel

sudo mkdir /var/www/
sudo chown ${USER} /var/www/
