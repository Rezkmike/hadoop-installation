#!/bin/bash

# Define Hadoop version
HADOOP_VERSION="3.2.3"

# Update the package index
apt-get update -y

# Install Java
apt-get install default-jdk wget -y

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
readlink -f /usr/bin/java | sed "s:bin/java::"

# Replace JAVA_HOME env
sed -i 's|# export JAVA_HOME=|export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-arm64/|' /usr/local/hadoop/etc/hadoop/hadoop-env.sh

# Run Hadoop
/usr/local/hadoop/bin/hadoop

mkdir ~/input
cp /usr/local/hadoop/etc/hadoop/*.xml ~/input

# Test Hadoop
/usr/local/hadoop/bin/hadoop jar /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-$HADOOP_VER.jar grep ~/input ~/grep_example 'allowed[.]*'

