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
 	HADOOP_DIR="hadoop-$HADOOP_VERSION"
        ;;
    "aarch64")
	wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6-aarch64.tar.gz -P ~/hadoop/
	HADOOP_BIN="hadoop-3.3.6-aarch64.tar.gz"
 	HADOOP_DIR="hadoop-3.3.6-aarch64"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

# Change workdir
cd ~/hadoop

# Unpack Hadoop and move to the home directory
tar -xzvf $HADOOP_BIN
echo 'export PATH=$PATH:~/hadoop/$HADOOP_DIR/bin' >> ~/.bashrc
echo 'export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")' >> ~/.bashrc
source ~/.bashrc

# Verify Hadoop installation
hadoop version

echo "Hadoop installation completed."
