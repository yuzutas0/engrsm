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

sudo yum --enablerepo=epel install -y nodejs
sudo yum --enablerepo=epel install -y npm
sudo npm install -g bower
bower -v

# ================================
# ready for app
# ================================

yum install -y mysql-devel

sudo mkdir -p /var/www/${APP}
sudo chown ${USER} /var/www/${APP}
