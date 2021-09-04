#!/bin/bash
# Create a Catkin Workspace
# Copyright (c) JetsonHacks, 2019-2021

# MIT License
# Maintainer of ARM builds for ROS is http://answers.ros.org/users/1034/ahendrix/
# Information from:
# http://wiki.ros.org/melodic/Installation/UbuntuARM
# 

source /opt/ros/melodic/setup.bash

# Usage setupCatkinWorkspace.sh dirName
help_usage ()
{
    echo "Usage: ./setupCatkinWorkspac.sh <path>"
    echo "  Setup a Catkin Workspace at the path indicated"
    echo "  Default path is ~/catkin_ws"
    echo "  -h | --help  This message"
    exit 0
}

CATKIN_DIR=""
 case $1 in
   -h | --help)           help_usage ;;
    *)                    CATKIN_DIR="$1" ;;
 esac


CATKIN_DIR=${CATKIN_DIR:="${HOME}/catkin_ws"}

if [ -e "$CATKIN_DIR" ] ; then
  echo "$CATKIN_DIR already exists; no action taken" 
  exit 1
else 
  echo "Creating Catkin Workspace: $CATKIN_DIR"
fi
echo "$CATKIN_DIR"/src
mkdir -p "$CATKIN_DIR"/src
cd "$CATKIN_DIR"/src
catkin_init_workspace
cd ..
catkin_make


echo "Catkin workspace: $CATKIN_DIR created"

