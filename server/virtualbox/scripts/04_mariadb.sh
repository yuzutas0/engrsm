#!/bin/bash

# ================================
# install & settings
# ================================

yum -y install mariadb mariadb-server

cat << _EOF > /etc/my.cnf.d/custom.cnf
[mysqld]
character-set-server=utf8mb4
collation-server=utf8mb4_unicode_ci
innodb-file-format=Barracuda
innodb-file-per-table=1
innodb-large-prefix=true
[client]
default-character-set=utf8mb4
_EOF

# ================================
# start
# ================================

systemctl start mariadb
systemctl enable mariadb

# ================================
# create user
# ================================

echo "*** answer is 'Y'"
echo "*** root password is ${ROOT_PASSWORD}"
echo "***"
mysql_secure_installation # => command

mysql -u root -p${ROOT_PASSWORD} -e "grant all privileges on *.* to ${USER}@localhost identified by '${PASSWORD}'"

# ================================
# TODO: create scheme by rails command
# ================================
