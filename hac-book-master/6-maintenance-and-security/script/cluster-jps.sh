#!/bin/bash
# Show all running Java processes on region servers. Must run on master using HBase owner user.

JAVA_HOME=/usr/local/jdk1.6
HBASE_HOME=/usr/local/hbase/current
IFS=$'\n'

printf "+------------------------------+----------+--------------------+\n"
printf "|%-30s|%-10s|%-20s|\n" " HOST" " PID" " PROCESS"
printf "+------------------------------+----------+--------------------+\n"
process_count=0
rs_count=0
for rs in `cat $HBASE_HOME/conf/regionservers`
do
    i=1
    for process in `ssh $rs "$JAVA_HOME/bin/jps" | grep -v Jps`
    do
        process_parts=(${process/ /$'\n'})
        pid=${process_parts[0]}
        pname=${process_parts[1]}
        if [ $i -eq 1 ]; then
            host="$rs"
        else
            host=" "
        fi
        printf "|%-30s|%-10s|%-20s|\n" " $host" " $pid" " $pname"

        i=`expr $i + 1`
        process_count=`expr $process_count + 1`
    done
    rs_count=`expr $rs_count + 1`
    printf "+------------------------------+----------+--------------------+\n"
done
echo -e "$process_count running Java processes on $rs_count region servers.\n"
