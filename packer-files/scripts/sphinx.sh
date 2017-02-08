#!/bin/bash

set -e
set -v

#Allows this script to run with super user privileges
echo "vagrant ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/init-users
cat /etc/sudoers.d/init-users

#Install necessary dependencies
#Needed to install dependencies silently
export DEBIAN_FRONTEND="noninteractive"

#Repository needed for ffmpeg
add-apt-repository ppa:mc3man/trusty-media

#Install Oracle Java 8
#This adds the needed repository to install Java.
aptitude install -y python-software-properties
echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | sudo tee -a /etc/apt/sources.list.d/webupd8team-java.list
echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | sudo tee -a /etc/apt/sources.list.d/webupd8team-java.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886

# Enable silent install for Java
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections

#Update package list
apt-get update

#Install all the packages needed for Factor: ffmpeg, Java
apt-get -y -q install ffmpeg dctrl-tools oracle-java8-installer

#Change which version of Java to use 
update-java-alternatives -s java-8-oracle

#Clears packaging cache? Needed to prevent the install from hanging
dpkg --clear-avail
sync-available

#Upgrade all packages to the latest needed for security reasons
apt-get -y upgrade


#Install Gradle to build Sphinx
wget https://services.gradle.org/distributions/gradle-3.3-bin.zip -P /opt
unzip /opt/gradle-3.3-bin.zip -d /opt
export PATH=/opt/gradle-3.3/bin:$PATH
rm /opt/gradle-3.3-bin.zip

# Installing vagrant keys
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub'
mkdir -p /home/vagrant/.ssh
chown -R vagrant:vagrant /home/vagrant/.ssh
cat ./vagrant.pub >> /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh/authorized_keys