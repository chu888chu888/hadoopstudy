#!/bin/bash

bin=`dirname $0`
bin=`cd $bin;pwd`

# output to hbase table directly
$HADOOP_HOME/bin/hadoop jar $bin/build/hac-chapter2.jar hac.chapter2.Recipe3 \
    hly_temp \
    /user/hac/input/2-3

# generate hfiles
#$HADOOP_HOME/bin/hadoop jar $bin/build/hac-chapter2.jar hac.chapter2.Recipe3 \
#    hly_temp \
#    /user/hac/input/2-3 \
#    /user/hac/output/2-3
