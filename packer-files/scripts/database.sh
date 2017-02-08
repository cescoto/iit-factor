#!/bin/bash

set -e
set -v

#Allows this script to run with super user privileges
echo "vagrant ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/init-users
cat /etc/sudoers.d/init-users

#Install necessary dependencies
#Needed to install dependencies silently
export DEBIAN_FRONTEND="noninteractive"
sudo debconf-set-selections <<< 'mariadb-server-10.1 mysql-server/root_password password PASS'
sudo debconf-set-selections <<< 'mariadb-server-10.1 mysql-server/root_password_again password PASS'
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
sudo add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://nyc2.mirrors.digitalocean.com/mariadb/repo/10.1/ubuntu trusty main'

#Update package list
apt-get update

#Install all the packages needed for Factor: MariaDB
apt-get -y -q install mariadb-server dctrl-tools

#Clears packaging cache? Needed to prevent the install from hanging
dpkg --clear-avail
sync-available

#Upgrade all packages to the latest needed for security reasons
apt-get -y upgrade

# Set mySQL password.
mysql -uroot -pPASS -e "SET PASSWORD = PASSWORD('vagrant');"

# Installing vagrant keys
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub'
mkdir -p /home/vagrant/.ssh
chown -R vagrant:vagrant /home/vagrant/.ssh
cat ./vagrant.pub >> /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh/authorized_keys