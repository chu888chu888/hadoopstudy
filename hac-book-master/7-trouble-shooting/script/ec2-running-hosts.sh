#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage: `basename $0` private|public"
    exit -1
fi

ec2-describe-instances > /tmp/all-instances
ip_type=$1
if [ "$ip_type" == "private" ]; then
    addresses=`grep ^INSTANCE /tmp/all-instances | cut -f18`
elif [ "$ip_type" == "public" ]; then
    addresses=`grep ^INSTANCE /tmp/all-instances | cut -f17`
else
    echo "Usage: `basename $0` private|public"
    exit -1
fi

for address in $addresses
do
    instance_id=`grep $address /tmp/all-instances | cut -f2`
    dns=`grep $address /tmp/all-instances | cut -f5`
    host=`grep ^TAG /tmp/all-instances | grep $instance_id | cut -f5`

    echo -e "${address}\t${dns}\t${host}"
done
