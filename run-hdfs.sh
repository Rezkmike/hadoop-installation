#!/bin/bash

TPL_PATH='./templates'
HADOOP_PATH='/usr/local/hadoop/etc/hadoop/'
HADOOP_BIN='/usr/local/hadoop/sbin'

# Start SSH service
service ssh start

mv -f $TPL_PATH/hdfs-site.conf $HADOOP_PATH/hdfs-site.conf
mv -f $TPL_PATH/core-site.conf $HADOOP_PATH/core-site.conf
mv -f $TPL_PATH/mapred-site.conf $HADOOP_PATH/mapred-site.conf
mv -f $TPL_PATH/yarn-site.conf $HADOOP_PATH/yarn-site.conf

# Test HDFS
/usr/local/hadoop/bin/hdfs namenode –format

# Create SSH Key
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

# Run HDFS
bash $HADOOP_BIN/start-all.sh
