#!/bin/bash

bin=`dirname $0`
bin=`cd $bin;pwd`

$bin/ec2-running-hosts.sh public | tee /tmp/ec2-running-host

# backup
cp /etc/hosts /tmp/hosts.org

# update
cp $bin/hosts.local /tmp/hosts.update
cat /tmp/ec2-running-host >> /tmp/hosts.update

sudo cp /tmp/hosts.update /etc/hosts
echo "[done] update EC2 public hostname in hosts file"
