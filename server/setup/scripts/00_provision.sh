#!/bin/bash

# ================================
# stop SELinux
# ================================

setenforce 0
sed -i -e "/^SELINUX=/c SELINUX=disabled" /etc/sysconfig/selinux

# ================================
# add group wheel
# ================================

usermod -aG wheel ${USER_NAME}
