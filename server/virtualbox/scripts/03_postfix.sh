#!/bin/bash

yum -y install postfix

echo ${DOMAIN_NAME}

postconf -e "myhostname = mail.${DOMAIN_NAME}"
postconf -e "mydomain = ${DOMAIN_NAME}"
postconf -e 'myorigin = $myhostname'
postconf -e 'inet_protocols = ipv4'
postconf -e 'smtpd_banner = $myhostname ESMTP unknown'

sudo systemctl restart postfix
sudo systemctl enable postfix

echo "send test mail to ${ADMIN_EMIAL}"
date | sendmail ${ADMIN_EMIAL}

echo "root: ${admin_email}" >> /etc/aliases
newaliases

echo "send test mail to ${ADMIN_EMIAL} !again!"
date | mail root
