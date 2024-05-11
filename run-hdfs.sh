#!/bin/bash

TPL_PATH='./templates'
HADOOP_PATH='/usr/local/hadoop/etc/hadoop/'
HADOOP_SBIN='/usr/local/hadoop/sbin'
HADOOP_BIN='/usr/local/hadoop/bin'

# Start SSH service
service ssh start

# Update template files
cp -rf $TPL_PATH/* $HADOOP_PATH/

# Test HDFS
$HADOOP_BIN/hdfs namenode –format

# Create SSH Key
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

# Run HDFS
bash $HADOOP_SBIN/start-all.sh
$HADOOP_BIN/hdfs fsck /
