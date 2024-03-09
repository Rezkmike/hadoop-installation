#!/bin/bash

# Script to install Hadoop on Ubuntu 20.04 for both AMD64 and ARM64 architectures

# Define Hadoop version
HADOOP_VERSION="3.2.3"

# Update the package index
apt-get update -y

# Install Java
apt-get install openjdk-8-jdk -y


echo $JAVA_HOME

## Verify Java installation
if type -p java; then
   echo Found Java executable in PATH
   _java=java
elif [[ -n "$JAVA_HOME" ]] && [[ -x "$JAVA_HOME/bin/java" ]];  then
   echo Found Java executable in JAVA_HOME     
   _java="$JAVA_HOME/bin/java"
else
   echo "No Java found. Please install Java 8."
   exit 1
fi

# Add a dedicated Hadoop system user
addgroup hadoop
adduser --ingroup hadoop --home /home/hadoop hadoop
adduser hadoop sudo

# Change to the Hadoop user
#su - hadoop

# Determine architecture
ARCH=$(uname -m)

# Download Hadoop based on architecture
case "$ARCH" in
    "x86_64")
        runuser -l hadoop -c 'wget http://apache.mirrors.pair.com/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz' -P /home/hadoop/hadoop-$HADOOP_VERSION.tar.gz
	HADOOP_BIN="hadoop-$HADOOP_VERSION.tar.gz"
        ;;
    "aarch64")
	runuser -l hadoop -c 'wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6-aarch64.tar.gz' -P /home/hadoop/hadoop-3.3.6-aarch64.tar.gz
	HADOOP_BIN="hadoop-3.3.6-aarch64.tar.gz"
	echo $HADOOP_BIN
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

# Unpack Hadoop and move to the home directory
#runuser -l hadoop -c 'tar -xzvf /home/hadoop/${HADOOP_BIN}' 
runuser -l hadoop -c 'tar -xzvf /home/hadoop/hadoop-3.3.6-aarch64.tar.gz' 
#runuser -l hadoop -c 'mv /home/hadoop/$HADOOP_BIN ~/hadoop'
runuser -l hadoop -c 'mv /home/hadoop/hadoop-3.3.6-aarch64.tar.gz ~/hadoop'

# Set up Hadoop environment variables
HOME_HADOOP="/home/hadoop/.bashrc"
HADOOP_HOME="/home/hadoop/hadoop-3.3.6"
chmod +x /home/hadoop/hadoop-3.3.6/bin/hadoop
echo 'export HADOOP_HOME=/home/hadoop/hadoop-3.3.6' >> $HOME_HADOOP 
echo 'export PATH=$PATH:$HADOOP_HOME/bin' >> $HOME_HADOOP 
echo 'export PATH=$PATH:$HADOOP_HOME/sbin' >> $HOME_HADOOP 
echo 'export HADOOP_MAPRED_HOME=$HADOOP_HOME' >> $HOME_HADOOP 
echo 'export HADOOP_COMMON_HOME=$HADOOP_HOME' >> $HOME_HADOOP 
echo 'export HADOOP_HDFS_HOME=$HADOOP_HOME' >> $HOME_HADOOP 
echo 'export YARN_HOME=$HADOOP_HOME' >> $HOME_HADOOP 
echo 'export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")' >> $HOME_HADOOP 

# Verify Hadoop installation
runuser -l hadoop -c 'source /home/hadoop/.bashrc ; hadoop version'
su - hadoop

# Exit from Hadoop user
exit

echo "Hadoop installation completed."
