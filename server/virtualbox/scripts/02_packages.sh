#!/bin/bash

sudo yum -y groups mark install "Development Tools"
sudo yum -y groups mark convert "Development Tools"
sudo yum -y groupinstall "Development Tools"

sudo yum -y install vim
