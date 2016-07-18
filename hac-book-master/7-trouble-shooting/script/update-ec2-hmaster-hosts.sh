#!/bin/bash
bin=`dirname $0`
bin=`cd $bin;pwd`

IFS_BAK=$IFS
IFS="
"
HMASTER_HOSTNAME="master1"
RS_HOSTNAMES="slave[123]"

scp $HMASTER_HOSTNAME:/tmp/hosts.org /tmp
scp $HMASTER_HOSTNAME:/etc/hosts /tmp

rm -f /tmp/hosts.done
while read line
do
    echo "$line" | egrep -q "$RS_HOSTNAMES"
    if [ $? -ne 0 ]; then
        echo -e "${line}" >> /tmp/hosts.done
    else
        slave=`echo "$line" | cut -f3`
        original_private_dns=`grep "$slave" /tmp/hosts.org | cut -f2`
        echo -e "${line}\t${original_private_dns}" >> /tmp/hosts.done
    fi
done < /tmp/hosts

bash $bin/update-ec2-hosts.sh "/tmp/hosts.done" "$HMASTER_HOSTNAME"
