#!/bin/sh

# JAVA
export JAVA_HOME=/usr/lib/jvm/default-java
export PATH=$JAVA_HOME/bin:$PATH

# OpenTSDB
kill -HUP `cat /home/hadoop/data/opentsdb/opentsdb.pid`
echo "Waiting for completing OpenTSDB shutdown..."
sleep 10

# HBase
export HBASE_HOME=/home/hadoop/app/hbase
export PATH=$HBASE_HOME/bin:$PATH

/home/hadoop/app/hbase/bin/stop-hbase.sh

# Hadoop
export HADOOP_HOME=/home/hadoop/app/hadoop
export PATH=$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH

/home/hadoop/app/hadoop/bin/stop-mapred.sh
/home/hadoop/app/hadoop/bin/stop-dfs.sh

