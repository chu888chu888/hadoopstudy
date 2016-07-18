#!/bin/bash

HBASE_HOME=/usr/local/hbase/current

zparent=`$HBASE_HOME/bin/hbase org.apache.hadoop.hbase.util.HBaseConfTool zookeeper.znode.parent`
if [ "$zparent" == "null" ]; then
    zparent="/hbase"
fi

online_regionservers=`$HBASE_HOME/bin/hbase zkcli ls $zparent/rs 2>&1 | tail -1 | sed "s/\[//" | sed "s/\]//"`
for rs in $online_regionservers
do
    rs_parts=(${rs//,/ })
    hostname=${rs_parts[0]}
    echo "Gracefully restarting: $hostname"
    $HBASE_HOME/bin/graceful_stop.sh --restart --reload  --debug $hostname
    sleep 1
done
