#!/bin/bash

set -e
set -v

#Allows this script to run with super user privileges
echo "vagrant ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/init-users
cat /etc/sudoers.d/init-users

#Install necessary dependencies
#Needed to install dependencies silently
export DEBIAN_FRONTEND="noninteractive"

#Update package list
apt-get update

#Install all the packages needed for Factor: Apache, PHP
apt-get -y -q install apache2 php5 libapache2-mod-php5 php5-mcrypt dctrl-tools

#Clears packaging cache? Needed to prevent the install from hanging
dpkg --clear-avail
sync-available

#Upgrade all packages to the latest needed for security reasons
apt-get -y upgrade

# Installing vagrant keys
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub'
mkdir -p /home/vagrant/.ssh
chown -R vagrant:vagrant /home/vagrant/.ssh
cat ./vagrant.pub >> /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh/authorized_keys