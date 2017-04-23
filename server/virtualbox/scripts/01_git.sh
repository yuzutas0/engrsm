#!/bin/bash

sudo yum -y install git

git config --global user.name "vagrant"
git config --global user.email "vagrant@127.0.0.1"

git clone https://github.com/yuzutas0/engrsm.git
