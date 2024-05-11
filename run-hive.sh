#!/bin/bash

sudo apt update
sudo apt-get install mysql-server mysqlimport

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
CREATE TABLE churn (customerID varchar(20),
  PaperlessBilling varchar(3),
  PaymentMethod varchar(30),
  MonthlyCharges numeric(8,2),
  Churn varchar(3));
EOF

sudo mysql -u root < /tmp/prepare.sql
