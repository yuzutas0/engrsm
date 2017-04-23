#!/bin/bash

cd server/staging

vagrant up

vagrant ssh

echo "password: vagrant"

ssh vagrant@127.0.0.1 -p 2222 'bash -x ' < ./scripts/01_git.sh

# TODO: use shellscipt at /home/vagrant/sync/
