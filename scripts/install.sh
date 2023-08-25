#!/bin/bash

sudo yum update -y
sudo yum upgrade -y

sudo yum install httpd -y
sudo yum start httpd -y
sudo yum enable httpd -y