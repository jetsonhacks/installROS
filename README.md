# installROS
Install Robot Operating System (ROS) Melodic on NVIDIA Jetson Developer Kits

These scripts will install Robot Operating System (ROS) Melodic on the NVIDIA Jetson Developer Kits. 

Jetson Nano, Jetson AGX Xavier, Jetson Xavier NX, Jetson TX2, Jetson TX1

The script is based on the Ubuntu ARM install of ROS Melodic: http://wiki.ros.org/melodic/Installation/Ubuntu

Maintainer of ARM builds for ROS is http://answers.ros.org/users/1034/ahendrix/

There are two scripts:

<strong>installROS.sh</strong>
<pre>
Usage: ./installROS.sh  [[-p package] | [-h]]
 -p | --package &lt;packagename&gt;  ROS package to install
                               Multiple Usage allowed
                               The first package should be a base package. One of the following:
                                 ros-melodic-ros-base
                                 ros-melodic-desktop
                                 ros-melodic-desktop-full
 </pre>
 
Default is ros-melodic-ros-base if no packages are specified.

Example Usage:

`$ ./installROS.sh -p ros-melodic-desktop -p ros-melodic-rgbd-launch`

This script installs a baseline ROS environment. There are several tasks:

* Enable repositories universe, multiverse, and restricted
* Adds the ROS sources list
* Sets the needed keys
* Loads specified ROS packages, defaults to ros-melodic-base-ros if none specified
* Initializes rosdep
* Sets up `ROS_MASTER_URI` and `ROS_IP` in the `~/.bashrc` file

_**Note:** You will need to check your `~/.bashrc` file to make sure the ROS_MASTER_URI and ROS_IP are setup correctly for your environment. During configuration, a best guess is made which should be considered a placeholder._

You can edit this file to add the ROS packages for your application. 

**setupCatkinWorkspace.sh**
Usage:

`$ ./setupCatkinWorkspace.sh [_optionalWorkspaceName_]`

where _optionalWorkspaceName_ is the name and path of the workspace to be used. The default workspace name is `~/catkin_ws`. 
 
## Release Notes

### September 2021
* v1.1
* Tested on L4T 32.6.1 (JetPack 4.6)
* Update ROS GPG Key
* Setup ROS_IP more intelligently
* Setup ROS_MASTER_URI and ROS_IP in installROS script instead of setupCatkinWorkspace
* Script wrangling and cleanup
* Thank you @hweizh for suggested ROS Key change!

### January 2020
* v1.0
* Tested on L4T 32.3.1 (JetPack 4.3)

## License
MIT License

Copyright (c) 2017-2021 JetsonHacks

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
 
