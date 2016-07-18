#/bin/bash

bin=`dirname $0`
bin=`cd $bin;pwd`

cp=$HBASE_HOME/conf:$HBASE_HOME/hbase-0.92.1.jar:$bin/build/hac-chapter2.jar
for jar in $bin/lib/*.jar
do
    cp=$cp:$jar
done
for jar in $HBASE_HOME/lib/*.jar
do
    cp=$cp:$jar
done

recipe=$1

$JAVA_HOME/bin/java -classpath $cp "hac.chapter2.Recipe1"
