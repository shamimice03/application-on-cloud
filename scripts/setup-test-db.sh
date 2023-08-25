#!/bin/bash
set -x

sudo yum install -y mariadb-server 
sudo systemctl enable mariadb
sudo systemctl start mariadb

RootPassword="password"
# Set Mariadb Root Password
sudo mysqladmin -u root password $RootPassword 

# MySQL credentials
REGION="ap-northeast-1"

DBPassword=$(aws ssm get-parameters --region $REGION --names /wordpress/db/DBPassword --with-decryption --query Parameters[0].Value)
DBPassword=$(echo $DBPassword | sed -e 's/^"//' -e 's/"$//')

DBUser=$(aws ssm get-parameters --region $REGION --names /wordpress/db/DBUser --query Parameters[0].Value)
DBUser=$(echo $DBUser | sed -e 's/^"//' -e 's/"$//')

# MySQL command to create the new user
MYSQL_CMD="CREATE USER '${DBUser}'@'localhost' IDENTIFIED BY '${DBPassword}';"

# Log in to MySQL and execute the commands
mysql -u root -p"${RootPassword}" -e "${MYSQL_CMD}"

# Flush privileges
mysql -u root -p"${RootPassword}" -e "FLUSH PRIVILEGES;"

