#!/bin/bash
# Install Robot Operating System (ROS) on NVIDIA Jetson Developer Kit
# Maintainer of ARM builds for ROS is http://answers.ros.org/users/1034/ahendrix/
# Information from:
# http://wiki.ros.org/melodic/Installation/UbuntuARM

# Red is 1
# Green is 2
# Reset is sgr0

function usage
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

function shouldInstallPackages
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

# Setup sources.lst
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
# Setup keys
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
# If you experience issues connecting to the keyserver, you can try substituting hkp://pgp.mit.edu:80 or hkp://keyserver.ubuntu.com:80 in the previous command.
# Installation
tput setaf 2
echo "Updating apt-get"
tput sgr0
sudo apt-get update
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
# Certificates are messed up on earlier version Jetson for some reason
# sudo c_rehash /etc/ssl/certs
# Initialize rosdep
tput setaf 2
echo "Initializaing rosdep"
tput sgr0
sudo rosdep init
# To find available packages, use:
rosdep update
# Environment Setup - Don't add /opt/ros/melodic/setup.bash if it's already in bashrc
grep -q -F 'source /opt/ros/melodic/setup.bash' ~/.bashrc || echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
source ~/.bashrc
# Install rosinstall
tput setaf 2
echo "Installing rosinstall tools"
tput sgr0
sudo apt-get install python-rosinstall python-rosinstall-generator python-wstool build-essential -y
tput setaf 2
echo "Installation complete!"
echo "Please setup your Catkin Workspace"
tput sgr0

