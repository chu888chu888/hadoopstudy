#!/bin/bash
# Sync HBASE_HOME across the cluster. Must run on master using HBase owner user.

HBASE_HOME=/usr/local/hbase/current

for rs in `cat $HBASE_HOME/conf/regionservers`
do
    echo "Deploying HBase to $rs:"
    rsync -avz --delete --exclude=logs $HBASE_HOME/ $rs:$HBASE_HOME/
    echo
    sleep 1
done

echo "Done"
