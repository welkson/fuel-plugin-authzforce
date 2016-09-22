#!/bin/bash
set -eux

# It's a script which deploys your plugin
echo fuel_plugin_authzforce > /tmp/fuel_plugin_authzforce

OS_NAME=''
if   grep -i CentOS /etc/issue.net >/dev/null; then
    OS_NAME='centos';
elif grep -i Ubuntu /etc/issue.net >/dev/null; then
    OS_NAME='ubuntu';
fi

function install_package {
    if [ $OS_NAME == 'ubuntu' ]; then
        apt-get install -y --force-yes -o 'APT::Get::AllowUnauthenticated=1' default-jdk tomcat7
    elif [ $OS_NAME == 'centos' ]; then
        yum install -y java-1.7.0-openjdk tomcat
    fi
}

install_package 
