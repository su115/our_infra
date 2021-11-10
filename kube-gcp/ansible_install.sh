#!/bin/bash

#mkdir ansible
#cd ansible
#mkdir tmp

sudo apt update
sudo apt upgrade -y
sudo apt install -y python3-pip
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 2
sudo pip3 install ansible
