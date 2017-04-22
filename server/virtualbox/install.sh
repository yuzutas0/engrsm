#!/bin/bash

cd server/staging

vagrant up # to start
vagrant status # to check "running"
vagrant halt # to stop
vagrant reload --provision # to reload settings
