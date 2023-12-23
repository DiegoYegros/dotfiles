#!/bin/bash

# Update package list
sudo apt update

# Install Alacritty
sudo apt install alacritty -y

# Install picom
sudo apt install picom -y 

# Install scrot for taking screenshots
sudo apt install scrot -y

# Just making sure you have python3
sudo apt install python3 -y

# Install psutil for the bumblebee-status CPU module
sudo apt install python3-psutil -y

# Install font-awesome for icons
sudo apt install fonts-font-awesome -y

# Install feh
sudo apt-get install -y feh 

# Install pygit2 for the git module in bumblebee-status
# Since pygit2 is a Python library, we use pip to install it
# Ensure pip is installed
sudo apt install python3-pip -y

pip3 install pygit2

# Install powerline-shell for ofc a pretty shell
git clone https://github.com/b-ryan/powerline-shell
cd powerline-shell
python setup.py install

echo "All required packages have been installed."

