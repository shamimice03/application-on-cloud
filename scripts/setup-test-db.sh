#!/bin/bash
set -x

# env setup
REGION="ap-northeast-1"

DBPassword=$(aws ssm get-parameters --region $REGION --names /wordpress/db/DBPassword --with-decryption --query Parameters[0].Value)
DBPassword=$(echo $DBPassword | sed -e 's/^"//' -e 's/"$//')

DBUser=$(aws ssm get-parameters --region $REGION --names /wordpress/db/DBUser --query Parameters[0].Value)
DBUser=$(echo $DBUser | sed -e 's/^"//' -e 's/"$//')

DBName=$(aws ssm get-parameters --region $REGION --names /wordpress/db/DBName --query Parameters[0].Value)
DBName=$(echo $DBName | sed -e 's/^"//' -e 's/"$//')

DBEndpoint=$(aws ssm get-parameters --region $REGION --names /wordpress/db/DBEndpoint --query Parameters[0].Value)
DBEndpoint=$(echo $DBEndpoint | sed -e 's/^"//' -e 's/"$//')

DBHostname=$(aws ssm get-parameters --region $REGION --names /wordpress/db/DBHostname --query Parameters[0].Value)
DBHostname=$(echo $DBHostname | sed -e 's/^"//' -e 's/"$//')

systemctl enable mariadb
systemctl start mariadb

# Set Mariadb Root Password
mysqladmin -u root password $DBPassword