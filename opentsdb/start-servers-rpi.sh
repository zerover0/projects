#!/bin/sh
# OpenTSDB start-up script for Raspberry Pi

# JAVA
export JAVA_HOME=/usr/lib/jvm/default-java
export PATH=$JAVA_HOME/bin:$PATH

# Hadoop
export HADOOP_HOME=/home/hadoop/app/hadoop
export PATH=$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH

echo "Starting Hadoop servers..."
/home/hadoop/app/hadoop/bin/start-dfs.sh
/home/hadoop/app/hadoop/bin/start-mapred.sh
echo "Waiting for Hadoop ready..."
sleep 30

# HBase
export HBASE_HOME=/home/hadoop/app/hbase
export PATH=$HBASE_HOME/bin:$PATH

echo "Starting HBase servers..."
/home/hadoop/app/hbase/bin/start-hbase.sh
echo "Waiting for HBase ready..."
sleep 60

# OpenTSDB
echo "Starting HBase servers..."
/home/hadoop/app/opentsdb/build/tsdb tsd --config=/home/hadoop/app/opentsdb/src/opentsdb.conf&
echo $! > /home/hadoop/data/opentsdb/opentsdb.pid

