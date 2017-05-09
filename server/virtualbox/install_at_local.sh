#!/bin/bash

# execute first at application root directory
# $ cd server/virtualbox && bash -x ./install_at_local.sh

work_dir='/home/vagrant/engrsm/server/setup'
capistrano_dir='/home/vagrant/engrsm'

# ================================
# setup vagrant
# ================================

vagrant up
ssh-keygen -R \[127.0.0.1\]:2222
ssh-keygen -R \[127.0.0.1\]:2200

# ================================
# install scripts to remote server
# ================================

echo "*** password: vagrant"
echo -n "*** Is it OK to continue? [yes/no]"
read answer

vagrant ssh engrsm -c "sudo bash -x " < ./../setup/scripts/00_provision.sh
vagrant ssh engrsm -c "USER_NAME=vagrant HOST_NAME=127.0.0.1 bash -x " < ./../setup/scripts/01_code.sh
vagrant ssh engrsm -c "find ${work_dir} -name "*.sh" | xargs chmod +x"

vagrant ssh deploy -c "sudo bash -x " < ./../setup/scripts/00_provision.sh
vagrant ssh deploy -c "USER_NAME=vagrant HOST_NAME=127.0.0.1 bash -x " < ./../setup/scripts/01_code.sh
vagrant ssh deploy -c "find ${work_dir} -name "*.sh" | xargs chmod +x"

# ================================
# setting custom variables
# ================================

db_root_password=$(cat /dev/urandom | LC_CTYPE=C tr -dc '[:alnum:]' | fold -w 16 | head -n 1)
echo "*** DB_ROOT_PASSWORD=${db_root_password}"
echo -n "*** Is it OK to continue? [yes/no]"
read answer

echo -n "*** Enter database password for custom user [password]"
read db_password
echo "*** Complete: DB_PASSWORD=${db_password}"
echo -n "*** Is it OK to continue? [yes/no]"
read answer

echo -n "*** Enter admin mail information. [xxx@xxx.xxx]"
read email
echo "*** Complete: EMAIL=${email}"
echo -n "*** Is it OK to continue? [yes/no]"
read answer

# ================================
# setting remote server
# ================================

vagrant ssh engrsm -c \
"cd ${work_dir} && EMAIL=${email} DB_ROOT_PASSWORD=${db_root_password} DB_PASSWORD=${db_password} \
bash -x ./install_at_server1.sh"

vagrant ssh deploy -c \
"cd ${work_dir} && DB_PASSWORD=${db_password} bash -x ./install_at_deploy.sh"

vagrant ssh engrsm -c \
"cd ${work_dir} && bash -x ./install_at_server2.sh"

vagrant ssh deploy -c "cd ${capistrano_dir} && bundle exec cap production deploy"
vagrant ssh engrsm -c "sudo systemctl restart nginx" # attention SELinux settings
