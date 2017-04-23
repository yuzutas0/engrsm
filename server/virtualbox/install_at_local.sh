#!/bin/bash

# ================================
# setup vagrant
# ================================
cd server/staging
vagrant up
ssh-keygen -R \[127.0.0.1\]:2222

# ================================
# install scripts to remote server
# ================================
echo "password: vagrant"
ssh vagrant@127.0.0.1 -p 2222 'find sync -name "*.sh" | xargs chmod +x'
ssh vagrant@127.0.0.1 -p 2222 'USER_NAME=vagrant HOST_NAME=127.0.0.1 bash -x' < ./scripts/01_code.sh

# ================================
# move to remote server
# ================================
echo "TODO: execute command `$ cd ./sync && bash -x ./install_at_remote.sh`"
vagrant ssh
