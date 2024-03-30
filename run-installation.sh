#!/bin/bash

# Define Hadoop version
HADOOP_VERSION="3.2.3"

# Update the package index
apt-get update -y

# Install Java
apt-get install default-jdk wget ssh git -y

# Check Java bersion
java -version

# Download Hadoop based on architecture
ARCH=$(uname -m)
case "$ARCH" in
    "x86_64")
        wget http://apache.mirrors.pair.com/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz -P /tmp
	HADOOP_BIN="hadoop-$HADOOP_VERSION.tar.gz"
 	HADOOP_DIR="hadoop-$HADOOP_VERSION"
  	HADOOP_VER=$HADOOP_VERSION
        ;;
    "aarch64")
	wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6-aarch64.tar.gz -P /tmp
	HADOOP_BIN="hadoop-3.3.6-aarch64.tar.gz"
 	HADOOP_DIR="hadoop-3.3.6-aarch64"
 	HADOOP_VER="3.3.6"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        # exit 1
        ;;
esac

# Change workdir
cd /tmp

# Unpack Hadoop and move to the home directory
tar -xzvf $HADOOP_BIN

# Move Hadoop folder 
mv hadoop-$HADOOP_VER /usr/local/hadoop

# Check Java_Home
JAVA_PATH=`readlink -f /usr/bin/java | sed "s:bin/java::"`

# Replace JAVA_HOME env
HADOOP_ENV_PATH='/usr/local/hadoop/etc/hadoop/hadoop-env.sh'
sed -i 's|# export JAVA_HOME=|export JAVA_HOME='"${JAVA_PATH}"'|' /usr/local/hadoop/etc/hadoop/hadoop-env.sh

# Add more env variable
echo 'export HDFS_NAMENODE_USER=root' >> $HADOOP_ENV_PATH
echo 'export HDFS_DATANODE_USER=root' >> $HADOOP_ENV_PATH
echo 'export HDFS_SECONDARYNAMENODE_USER=root' >> $HADOOP_ENV_PATH
echo 'export YARN_RESOURCEMANAGER_USER=root' >> $HADOOP_ENV_PATH
echo 'export YARN_NODEMANAGER_USER=root' >> $HADOOP_ENV_PATH

# Run Hadoop
/usr/local/hadoop/bin/hadoop

mkdir ~/input
cp /usr/local/hadoop/etc/hadoop/*.xml ~/input

# Test Hadoop
/usr/local/hadoop/bin/hadoop jar /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-$HADOOP_VER.jar grep ~/input ~/grep_example 'allowed[.]*'

