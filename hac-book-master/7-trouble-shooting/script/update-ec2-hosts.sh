#!/bin/bash

if [ $# -lt 2 ]; then
    echo "Usage: `basename $0` host-file target-host"
    exit 1
fi
host_file=$1
target_host=$2

bin=`dirname $0`
bin=`cd $bin;pwd`

echo "updating hosts file on $target_host using $host_file"
# backup
ssh -f $target_host "cp /etc/hosts /tmp/hosts.org"

cp $bin/hosts.template /tmp/hosts.update
cat $host_file >> /tmp/hosts.update
scp /tmp/hosts.update $target_host:/tmp

# chmod 700 this file as we write password here
ssh -f -t -t -t $target_host "sudo -S cp /tmp/hosts.update /etc/hosts <<EOF
your_password
EOF
"
echo "[done] update hosts file on $target_host"
