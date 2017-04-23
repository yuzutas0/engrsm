#!/bin/bash

cd server/staging

vagrant up

ssh-keygen -R \[127.0.0.1\]:2222

echo "password: vagrant"

ssh vagrant@127.0.0.1 -p 2222 'bash -x ' < ./scripts/01_git.sh

# TODO: use shell script at /home/vagrant/sync/
