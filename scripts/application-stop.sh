#!/bin/bash
set -x

# System control will return either "active" or "inactive".
tomcat_running=$(systemctl is-active httpd)
if [ "$tomcat_running" == "active" ]; then
    sudo systemctl stop httpd
fi