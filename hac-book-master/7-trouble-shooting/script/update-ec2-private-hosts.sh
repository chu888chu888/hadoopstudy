#!/bin/bash

bin=`dirname $0`
bin=`cd $bin;pwd`
NS_HOSTNAME="ns1"

$bin/ec2-running-hosts.sh private | tee /tmp/ec2-running-host

cp $bin/hosts.template /tmp/hosts.update
cat /tmp/ec2-running-host >> /tmp/hosts.update

while read line
do
    host=`echo "$line" | cut -f3`
    if [ "$host" == "$NS_HOSTNAME" ]; then
        # do not update name server
        continue
    fi
    echo
    echo "Updating $host"

    bash $bin/update-ec2-hosts.sh "/tmp/ec2-running-host" "$host"
    sleep 1
done < /tmp/ec2-running-host
