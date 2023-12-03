#!/bin/bash

echo 'Hello, World!' > /tmp/hello.txt

sudo apt-get update
sudo apt-get -y upgrade

sudo apt-get -y install build-essential
sudo apt-get -y install nginx 
sudo apt-get -y install git 
sudo apt-get -y install python3
sudo apt-get -y install python3-pip

sudo systemctl restart nginx