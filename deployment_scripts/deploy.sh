#!/bin/bash
set -eux

# It's a script which deploys your plugin
echo fuel_plugin_authzforce > /tmp/fuel_plugin_authzforce

function install_package {
    # env
    export DEBIAN_FRONTEND=noninteractive
    export PACKAGE_VERSION=5.4.1

    # update APT repositories
    sudo -E apt-get update --assume-yes -qq
    sudo -E apt-get install --assume-yes -qq gdebi curl debconf-utils

    # install Java and Tomcat
    apt-get install -y --force-yes -o 'APT::Get::AllowUnauthenticated=1' default-jdk tomcat7

    # Download AuthZForce deb package
    sudo curl --silent --remote-name --location http://repo1.maven.org/maven2/org/ow2/authzforce/authzforce-ce-server-dist/${PACKAGE_VERSION}/authzforce-ce-server-dist-${PACKAGE_VERSION}.deb 
  
    # Prevent Tomcat restart before change to JAVA_OPTS applied later
    sudo bash -c "echo authzforce-ce-server	authzforce-ce-server/restartTomcat	boolean	false | debconf-set-selections"
    sudo bash -c "echo authzforce-ce-server	authzforce-ce-server/keepSamples	boolean	true | debconf-set-selections"

    # Install AuthZForce package
    sudo -E gdebi --quiet --non-interactive authzforce-ce-server-dist-${PACKAGE_VERSION}.deb 

    # Java XMX Parameters
    sudo sed -i 's/-Xmx128m/-Xmx1024m/' /etc/default/tomcat7 

    # restart tomcat
    sudo service tomcat7 restart
}

install_package

