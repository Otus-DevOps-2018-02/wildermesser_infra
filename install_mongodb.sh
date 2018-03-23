#!/bin/bash

echo "Setting mongodb repo"
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'

echo "Installing mongodb"
sudo apt update
sudo apt install -y mongodb-org

echo "Enabling and starting mongodb"
sudo systemctl start mongod
sudo systemctl enable mongod

mongodb_status=`sudo systemctl | grep mongod | awk {'print $4'}`
if [ $mongodb_status='running' ]
then
  echo "Mongodb is running"
else
  echo "Mongodb is not running, check systemctl status mongod"
fi
