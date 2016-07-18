#!/bin/bash

bin=`dirname $0`
bin=`cd $bin;pwd`

IFS_BAK=$IFS
IFS="
"

# TODO get hostname, hosts, hosts.org from parameters
scp l-master1:/tmp/hosts.org /tmp
scp l-master1:/etc/hosts /tmp

rm -f /tmp/hosts.done
while read line
do
    echo "$line" | egrep -q l-slave[123]
    if [ $? -ne 0 ]; then
        echo -e "${line}" >> /tmp/hosts.done
    else
        slave=`echo "$line" | cut -f3`
        original_private_dns=`grep "$slave" /tmp/hosts.org | cut -f2`
        echo -e "${line}\t${original_private_dns}" >> /tmp/hosts.done
    fi
done < /tmp/hosts

bash $bin/update-ec2-hosts.sh "/tmp/hosts.done" "l-master1"
exit 0
