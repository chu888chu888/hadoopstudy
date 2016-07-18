#!/bin/bash

#you will need to set up your DNS server to allow update from this key
#use dnssec-keygen to generate your keys
DNS_KEY=/root/etc/Kuser.hbase-admin-cookbook.com.+157+44141.private
DOMAIN=hbase-admin-cookbook.com

USER_DATA=`/usr/bin/curl -s http://169.254.169.254/latest/user-data`
HOSTNAME=`echo $USER_DATA`
#set also the hostname to the running instance
hostname $HOSTNAME

LOCIP=`/usr/bin/curl -s http://169.254.169.254/latest/meta-data/local-ipv4`
cat<<EOF | /usr/bin/nsupdate -k $DNS_KEY -v
server 10.160.49.250
zone $DOMAIN
update delete $HOSTNAME.$DOMAIN A
update add $HOSTNAME.$DOMAIN 60 A $LOCIP
send
EOF
