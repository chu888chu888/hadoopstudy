#!/bin/bash

bin=`dirname $0`
bin=`cd $bin;pwd`

$HADOOP_HOME/bin/hadoop jar $bin/build/hac-chapter5.jar hac.chapter5.WriteDiagnosis $*
