#!/bin/bash

cd server/staging

vagrant up

ssh-keygen -R \[127.0.0.1\]:2222

echo "password: vagrant"

ssh vagrant@127.0.0.1 -p 2222 'find sync -name "*.sh" | xargs chmod +x'

# TODO: use shell script at /home/vagrant/sync/
# but these scripts are used to setup production too. (Therefore, it will be moved to other folder)
ssh vagrant@127.0.0.1 -p 2222 'bash -x ' < ./scripts/01_git.sh

# TODO: postfix
# TODO: mariadb or mysql
# TODO: redis
# TODO: elasticsearch
# TODO: ruby
# TODO: rails
# TODO: nginx
# TODO: let's encrypt
