#!/bin/bash

# ================================
# clean
# ================================

sudo yum remove -y ruby

# ================================
# install rbenv
# ================================

git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
source ~/.bash_profile

git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
sudo ~/.rbenv/plugins/ruby-build/install.sh

# ================================
# install ruby
# ================================

sudo yum install -y openssl-devel readline-devel zlib-devel libffi-devel gcc

rbenv install ${VERSION}
rbenv rehash
rbenv global ${VERSION}

# ================================
# test
# ================================

ruby -v
which ruby
which gem
