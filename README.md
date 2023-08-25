# application-on-cloud
A demo application for GitHub Actions, S3, S3 mountpoint integration test

![image](https://github.com/shamimice03/application-on-cloud/assets/19708705/74877bac-478e-4509-952e-465c134f553d)
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::391178969547:oidc-provider/token.actions.githubusercontent.com"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
                },
                "StringLike": {
                    "token.actions.githubusercontent.com:sub": "repo:shamimice03/application001:ref:refs/heads/main"
                }
            }
        }
    ]
}
```

![image](https://github.com/shamimice03/application-on-cloud/assets/19708705/3bfc1bbb-78d4-4565-9e60-97466e28563a)


![image](https://github.com/shamimice03/application-on-cloud/assets/19708705/6bd4f669-4fc0-4423-88f9-0a3357b2d56e)


```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Principal": {
                "Federated": "arn:aws:iam::391178969547:oidc-provider/token.actions.githubusercontent.com"
            },
            "Condition": {
                "StringEquals": {
                    "token.actions.githubusercontent.com:aud": [
                        "sts.amazonaws.com"
                    ],
                    "token.actions.githubusercontent.com:sub": [
                        "repo:shamimice03/application001:ref:refs/heads/main"
                    ]
                }
            }
        }
    ]
}
```


`appspec.yaml` hooks:
- https://docs.aws.amazon.com/codedeploy/latest/userguide/reference-appspec-file.html
- https://docs.aws.amazon.com/codedeploy/latest/userguide/reference-appspec-file-structure-hooks.html
![image](https://github.com/shamimice03/AWS-Notes/assets/19708705/3d367de8-c93e-40a5-8eed-cff39579e772)

```

#!/bin/bash

# System Updates
sudo yum -y update
sudo yum -y upgrade

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

EFSID=$(aws ssm get-parameters --region $REGION --names /wordpress/efs/EFSID --query Parameters[0].Value)
EFSID=$(echo $EFSID | sed -e 's/^"//' -e 's/"$//')

# Install the application dependencies you need for WordPress
sudo yum install -y httpd wget 
sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2

# Download and install Composer globally
sudo curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# Verify Composer installation
composer --version

# Install the Amazon EFS utilities
sudo yum -y install amazon-efs-utils

# Install s3-mount utilities
wget https://s3.amazonaws.com/mountpoint-s3-release/latest/x86_64/mount-s3.rpm
sudo yum install -y ./mount-s3.rpm
sudo rm -rf mount-s3.rpm

# Start and enable Webserver
sudo systemctl enable httpd
sudo systemctl start httpd

# Mount the EFS file system
# Add an entry to /etc/fstab to mount the EFS file system
sudo mkdir -p /var/www/media
sudo chown -R ec2-user:apache /var/www/
echo -e "$EFSID:/ /var/www/media efs _netdev,tls,iam 0 0" | sudo tee -a /etc/fstab
sudo mount -a -t efs defaults

# create .env file inside /var/www/html
mkdir -p /var/www/env
touch /var/www/env/.env
echo DBHostname="$DBHostname" > /var/www/env/.env
echo DBUser="$DBUser" >> /var/www/env/.env
echo DBName="$DBName" >> /var/www/env/.env
echo DBPassword="$DBPassword" >> /var/www/env/.env

# Get the UID of ec2-user
ec2_user_uid=$(id -u ec2-user)

# Get the GID of apache
apache_gid=$(id -g apache)

# Run the mount-s3 command with the obtained UID and GID values
mount-s3 application001 /var/www/html/ --uid=$ec2_user_uid --gid=$apache_gid

# composer on working dir
composer require vlucas/phpdotenv --working-dir=/var/www/html

```