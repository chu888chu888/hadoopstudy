#!/bin/bash

export HBASE_CLASSPATH=$HBASE_CLASSPATH:./
$HBASE_HOME/bin/hbase org.apache.hadoop.hbase.util.RegionSplitter -D split.algorithm=FileSplitAlgorithm -c 2 -f f1 test_table
