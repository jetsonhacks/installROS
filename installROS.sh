#!/bin/bash
# Install ROS on NVIDIA Jetson Developer Kits
# Copyright (c) JetsonHacks, 2019-2021

# MIT License
# Maintainer of ARM builds for ROS is http://answers.ros.org/users/1034/ahendrix/
# Information from:
# http://wiki.ros.org/melodic/Installation/UbuntuARM

# Get code name of distribution
# lsb_release gets the Ubuntu Description Release and Code name
DISTRIBUTION_CODE_NAME=$( lsb_release -sc )

case $DISTRIBUTION_CODE_NAME in
  "xenial" )
    echo "This Ubuntu distribution is Ubuntu Xenial (16.04)"
    echo "This install is not the ROS recommended version for Ubuntu Xenial."
    echo "ROS Bionic is the recommended version."
    echo "This script installs ROS Melodic. You will need to modify it for your purposes."
    exit 0
  ;;
  "bionic")
    echo "This Ubuntu distribution is Ubuntu Bionic (18.04)"
    echo "Installing ROS Melodic"
  ;;
  *)
    echo "This distribution is $DISTRIBUTION_CODE_NAME"
    echo "This script will only work with Ubuntu Xenial (16.04) or Bionic (18.04)"
    exit 0
esac

# Install Robot Operating System (ROS) on NVIDIA Jetson Developer Kit
# Maintainer of ARM builds for ROS is http://answers.ros.org/users/1034/ahendrix/
# Information from:
# http://wiki.ros.org/melodic/Installation/UbuntuARM

# Red is 1
# Green is 2
# Reset is sgr0

usage ()
{
    echo "Usage: ./installROS.sh [[-p package] | [-h]]"
    echo "Install ROS Melodic"
    echo "Installs ros-melodic-ros-base as default base package; Use -p to override"
    echo "-p | --package <packagename>  ROS package to install"
    echo "                              Multiple usage allowed"
    echo "                              Must include one of the following:"
    echo "                               ros-melodic-ros-base"
    echo "                               ros-melodic-desktop"
    echo "                               ros-melodic-desktop-full"
    echo "-h | --help  This message"
}

shouldInstallPackages ()
{
    tput setaf 1
    echo "Your package list did not include a recommended base package"
    tput sgr0 
    echo "Please include one of the following:"
    echo "   ros-melodic-ros-base"
    echo "   ros-melodic-desktop"
    echo "   ros-melodic-desktop-full"
    echo ""
    echo "ROS not installed"
}

# Iterate through command line inputs
packages=()
while [ "$1" != "" ]; do
    case $1 in
        -p | --package )        shift
                                packages+=("$1")
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done
# Check to see if other packages were specified
# If not, set the default base package
if [ ${#packages[@]}  -eq 0 ] ; then
 packages+="ros-melodic-ros-base"
fi
echo "Packages to install: "${packages[@]}
# Check to see if we have a ROS base kinda thingie
hasBasePackage=false
for package in "${packages[@]}"; do
  if [[ $package == "ros-melodic-ros-base" ]]; then
     hasBasePackage=true
     break
  elif [[ $package == "ros-melodic-desktop" ]]; then
     hasBasePackage=true
     break
  elif [[ $package == "ros-melodic-desktop-full" ]]; then
     hasBasePackage=true
     break
  fi
done
if [ $hasBasePackage == false ] ; then
   shouldInstallPackages
   exit 1
fi

# Let's start installing!

tput setaf 2
echo "Adding repository and source list"
tput sgr0
sudo apt-add-repository universe
sudo apt-add-repository multiverse
sudo apt-add-repository restricted

tput setaf 2
echo "Updating apt"
tput sgr0
sudo apt update

# Setup sources.lst
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
# Setup keys
sudo apt install curl 
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -

tput setaf 2
echo "Updating apt"
tput sgr0
sudo apt update
tput setaf 2
echo "Installing ROS"
tput sgr0
# This is where you might start to modify the packages being installed, i.e.
# sudo apt-get install ros-melodic-desktop

# Here we loop through any packages passed on the command line
# Install packages ...
for package in "${packages[@]}"; do
  sudo apt-get install $package -y
done

# Add Individual Packages here
# You can install a specific ROS package (replace underscores with dashes of the package name):
# sudo apt-get install ros-melodic-PACKAGE
# e.g.
# sudo apt-get install ros-melodic-navigation
#
# To find available packages:
# apt-cache search ros-melodic
# 
# Initialize rosdep
tput setaf 2
echo "Installing rosdep"
tput sgr0
sudo apt-get install python-rosdep -y
# Initialize rosdep
tput setaf 2
echo "Initializaing rosdep"
tput sgr0
sudo rosdep init
# To find available packages, use:
rosdep update
# Environment Setup - source melodic setup.bash
# Don't add /opt/ros/melodic/setup.bash if it's already in bashrc
grep -q -F 'source /opt/ros/melodic/setup.bash' ~/.bashrc || echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
source ~/.bashrc
# Install rosinstall
tput setaf 2
echo "Installing rosinstall tools"
tput sgr0

# Install useful ROS dev tools
sudo apt-get install -y python-rosinstall \
  python-rosinstall-generator \
  python-wstool \
  build-essential

# Use ip to get the current IP addresses of eth0 and wlan0; parse into form xx.xx.xx.xx
ETH0_IPADDRESS=$(ip -4 -o addr show eth0 | awk '{print $4}' | cut -d "/" -f 1)
WLAN_IPADDRESS=$(ip -4 -o addr show wlan0 | awk '{print $4}' | cut -d "/" -f 1)

if [ -z "$ETH0_IPADDRESS" ] ; then
  echo "Ethernet (eth0) is not available"
else
  echo "Ethernet (eth0) is $ETH0_IPADDRESS"
fi
if [ -z "$WLAN_IPADDRESS" ] ; then
  echo "Wireless (wlan0) is not available"
else
  echo "Wireless (wlan0) ip address is $WLAN_IPADDRESS"
fi

# Default to eth0 if available; wlan0 next
ROS_IP_ADDRESS=""
if [ ! -z "$ETH0_IPADDRESS" ] ; then
  ROS_IP_ADDRESS=$ETH0_IPADDRESS
else
  ROS_IP_ADDRESS=$WLAN_IPADDRESS
fi
if [ ! -z "$ROS_IP_ADDRESS" ] ; then
  echo "Setting ROS_IP in ${HOME}/.bashrc to: $ROS_IP_ADDRESS"
else
  echo "Setting ROS_IP to empty. Please change ROS_IP in the ${HOME}/.bashrc file"
fi

#setup ROS environment variables
grep -q -F ' ROS_MASTER_URI' ~/.bashrc ||  echo 'export ROS_MASTER_URI=http://localhost:11311' | tee -a ~/.bashrc
grep -q -F ' ROS_IP' ~/.bashrc ||  echo "export ROS_IP=${ROS_IP_ADDRESS}" | tee -a ~/.bashrc
tput setaf 2

echo "Installation complete!"
echo "Please setup your Catkin Workspace"
tput sgr0

