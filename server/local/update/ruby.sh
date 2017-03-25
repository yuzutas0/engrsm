#!/bin/bash

new_version=2.3.3 # TODO: dynamic setting

brew update
brew upgrade rbenv ruby-build
rbenv install --list # => ${new_version}

rbenv install ${new_version}
rbenv global ${new_version}
ruby -v # => ${new_version}

rbenv exec gem install bundler
rbenv rehash
rbenv exec bundler -v
