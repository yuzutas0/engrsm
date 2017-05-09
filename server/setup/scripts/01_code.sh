#!/bin/bash

sudo yum -y install git

git config --global user.name "${USER_NAME}"
git config --global user.email "${USER_NAME}@${HOST_NAME}"

git clone https://github.com/yuzutas0/engrsm.git
