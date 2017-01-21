#!/bin/bash

# ================================
# variables
# ================================

# after DNS settings
host_name=$1
domain_name=$2
admin_email=$3

# ================================
# install & settings
# ================================

su

yum -y install postfix

vim /etc/postfix/main.cf
# ------------------------------------------------------------------------------------------------------------
# from: #myhostname = virtual.domain.tld
# to:   myhostname = ${host_name}.${domain_name}
# ------------------------------------------------------------------------------------------------------------
# from: #mydomain = domain.tld
# to:   mydomain = ${domain_name}
# ------------------------------------------------------------------------------------------------------------
# from: #myorigin = $mydomain
# to:   myorigin = $myhostname
# ------------------------------------------------------------------------------------------------------------
# from: inet_protocols = all
# to:   inet_protocols = ipv4
# ------------------------------------------------------------------------------------------------------------
# from: #smtpd_banner = $myhostname ESMTP $mail_name
# to:   smtpd_banner = $myhostname ESMTP unknown
# ------------------------------------------------------------------------------------------------------------

systemctl restart postfix
systemctl enable postfix

# ================================
# test
# ================================

date | sendmail ${admin_email}
# check whether admin receives email from server
