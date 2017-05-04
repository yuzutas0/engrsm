#!/bin/bash

# ================================
# settings
# ================================

cat << _EOF > /etc/logrotate.d/unicorn
/var/www/${APP}/shared/log/production.log {
  weekly
  rotate 4
  missingok
  notifempty
  copytruncate
  create 0664 wheel ${USER}
    minsize 1M
  lastaction
    pid=/tmp/unicorn.pid
    test -s \$pid && kill -USR1 "\$(cat \$pid)"
  endscript
}
_EOF
