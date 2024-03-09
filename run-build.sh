#!/bin/bash

# Script to install Hadoop on Ubuntu 20.04 for both AMD64 and ARM64 architectures

# Define Hadoop version
HADOOP_VERSION="3.2.3"

# Update the package index
apt-get update -y

# Install Java
apt-get install openjdk-8-jdk wget -y

# Determine architecture
ARCH=$(uname -m)
mkdir -p ~/hadoop

# Download Hadoop based on architecture
case "$ARCH" in
    "x86_64")
        wget http://apache.mirrors.pair.com/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz -P ~/hadoop/
	HADOOP_BIN="hadoop-$HADOOP_VERSION.tar.gz"
        ;;
    "aarch64")
	wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6-aarch64.tar.gz -P ~/hadoop/
	HADOOP_BIN="hadoop-3.3.6-aarch64.tar.gz"
	echo $HADOOP_BIN
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

# Unpack Hadoop and move to the home directory
tar -xzvf ~/hadoop/$HADOOP_BIN
rm -rf ~/hadoop/$HADOOP_BIN
cp /root/hadoop/hadoop-3.3.6/bin/hadoop /usr/local/bin

# Verify Hadoop installation
hadoop version

echo "Hadoop installation completed."
