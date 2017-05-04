#!/bin/bash

# execute first

# ================================
# setup vagrant
# ================================
cd server/staging
vagrant up
ssh-keygen -R \[127.0.0.1\]:2222
ssh-keygen -R \[127.0.0.1\]:2200

# ================================
# install scripts to remote server
# ================================
echo "*** password: vagrant"
ssh vagrant@127.0.0.1 -p 2222 'find sync -name "*.sh" | xargs chmod +x'
ssh vagrant@127.0.0.1 -p 2222 'USER_NAME=vagrant HOST_NAME=127.0.0.1 bash -x' < ./sync/scripts/01_code.sh
ssh vagrant@127.0.0.1 -p 2200 'find sync -name "*.sh" | xargs chmod +x'
ssh vagrant@127.0.0.1 -p 2200 'USER_NAME=vagrant HOST_NAME=127.0.0.1 bash -x' < ./sync/scripts/01_code.sh

# ================================
# move to remote server
# ================================
db_root_password=$(cat /dev/urandom | LC_CTYPE=C tr -dc '[:alnum:]' | fold -w 16 | head -n 1)

echo "*** DB_ROOT_PASSWORD=${db_root_password}"
echo "***"
echo '*** TODO: execute command `$ cd ./sync && EMAIL={your email address} DB_ROOT_PASSWORD={above value} DB_PASSWORD={random value} bash -x ./install_at_server1.sh`'
vagrant ssh engrsm

echo "*** DB_ROOT_PASSWORD=${db_root_password}"
echo "***"
echo '*** TODO: execute command `$ cd ./sync && DB_PASSWORD={your database password} bash -x ./install_at_deploy.sh`'
vagrant ssh deploy

echo "*** DB_ROOT_PASSWORD=${db_root_password}"
echo "***"
echo '*** TODO: execute command `$ cd ./sync && bash -x ./install_at_server2.sh`'
vagrant ssh engrsm

# TODO: execute command by ssh
