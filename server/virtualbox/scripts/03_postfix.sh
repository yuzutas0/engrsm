#!/bin/bash

yum -y install postfix

postconf -e "myhostname = mail.${DOMAIN_NAME}"
postconf -e "mydomain = ${DOMAIN_NAME}"
postconf -e 'myorigin = $myhostname'
postconf -e 'inet_protocols = ipv4'
postconf -e 'smtpd_banner = $myhostname ESMTP unknown'

sudo systemctl restart postfix
sudo systemctl enable postfix

echo "*** send test mail to ${ADMIN_EMAIL}"
date | sendmail ${ADMIN_EMAIL}
# => $ sudo tail /var/log/maillog
# connect to xxx.google.com[xxx.xxx.xxx.xxx]:25: Connection timed out

echo "root: ${ADMIN_EMAIL}" >> /etc/aliases
newaliases

echo "*** send test mail to ${ADMIN_EMAIL} !again!"
date | sendmail root
# => $ sudo tail /var/log/maillog
# connect to xxx.google.com[xxx.xxx.xxx.xxx]:25: Connection timed out
