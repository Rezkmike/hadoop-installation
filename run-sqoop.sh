#!/bin/bash

sudo apt update
sudo apt-get install -y mysql-server git

# Check mysql service running
SERVICE="mysql"

# Check the status of the MySQL service
if systemctl is-active --quiet $SERVICE; then
    echo "$SERVICE service is running."
else
    echo "$SERVICE service is not running. Attempting to start $SERVICE..."
    # Try to start the service
    sudo systemctl start $SERVICE
    
    # Check if the service started successfully
    if systemctl is-active --quiet $SERVICE; then
        echo "$SERVICE service has been started successfully."
    else
        echo "Failed to start $SERVICE service."
    fi
fi

# Prepare sql script
cat << EOF > /tmp/prepare.sql
CREATE DATABASE WQD7007;
USE WQD7007;
CREATE TABLE churn (customerID varchar(20), PaperlessBilling varchar(3), PaymentMethod varchar(30), MonthlyCharges numeric(8,2), Churn varchar(3));
SET GLOBAL local_infile=true;
ALTER USER 'root'@'localhost' IDENTIFIED BY 'root';
FLUSH PRIVILEGES;
EOF

# Create mysql database
sudo mysql -uroot -proot < /tmp/prepare.sql

# Import dataset into the dataset
sudo mysql -uroot -proot --local_infile=1 WQD7007 \
    -e \
    "LOAD DATA LOCAL INFILE './dataset/churn_reduced.csv' INTO TABLE churn FIELDS TERMINATED BY ','"

# Download Hive
wget -O /tmp/sqoop-1.4.7.tar.gz https://archive.apache.org/dist/sqoop/1.4.7/sqoop-1.4.7.tar.gz
tar -xzf /tmp/sqoop-1.4.7.tar.gz
cp -r sqoop-1.4.7 $HOME/sqoop/

# Export path
echo "export PATH=$PATH:$HOME/sqoop/bin" >> ~/.bashrc
echo "HADOOP_COMMON_HOME=$HOME/hadoop" >> ~/.bashrc
echo "HADOOP_MAPRED_HOME=$HOME/hadoop" >> ~/.bashrc
source ~/.bashrc

# Update template
mv -f $HOME/sqoop/conf/sqoop-env-template.sh $HOME/sqoop/conf/sqoop-env.sh

# Copy connector
cp ./connector/mysql-connector-java-5.1.47.jar $HOME/sqoop/lib

sqoop import -connect jdbc:mysql://localhost/WQD7007 \
    -username root \
    -password root \
    -table churn -m 1

hdfs dfs -cat $HOME/churn/*
