#!/bin/bash

# ================================
# settings & start app
# ================================

cat << _EOF > /etc/systemd/system/${APP}_unicorn.service
[Unit]
Description=${APP} Unicorn Server
After=mariadb.service

[Service]
User=${USER}
WorkingDirectory=/var/www/${APP}/current
Environment=RAILS_ENV=production
SyslogIdentifier=${APP}_unicorn
PIDFile=/var/www/${APP}/shared/tmp/pids/unicorn.pid

ExecStart=/home/${USER}/.rbenv/bin/rbenv exec bundle exec "unicorn -c config/unicorn/production.rb -E production"
ExecStop=/usr/bin/kill -QUIT \$MAINPID
ExecReload=/bin/kill -USR2 \$MAINPID

[Install]
WantedBy=multi-user.target
_EOF

systemctl daemon-reload
systemctl enable ${APP}_unicorn

# ================================
# enable restart without password
# ================================

# ready syntax test
tmp=`mktemp -t vagrant_sudors.XXX`
cat /etc/sudoers > ${tmp}

# %wheel ALL=(ALL) NOPASSWD: ALL
sed -i -e "s/^%wheel/#%wheel/" ${tmp} # => disable : with password
sed -i -e "s/^# %wheel/%wheel/" ${tmp} # => enable : without password

# enable unicorn command to app user
echo -e "${USER} ALL=NOPASSWD: /bin/systemctl * ${APP}_unicorn\n" >> ${tmp}

# test and rewrite
visudo -c -f ${tmp}
if [ $? -eq 0 ]; then
    echo '*** Pass Syntax Test - visudo'
    cat ${tmp} > /etc/sudoers
else
    echo '*** Syntax Error! - visudo'
fi
rm -f ${tmp}
