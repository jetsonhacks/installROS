# installROS
Install Robot Operating System (ROS) on NVIDIA Jetson Developer Kits

These scripts will install Robot Operating System (ROS) on the NVIDIA Jetson Developer Kits. 

Jetson TX2, Jetson AGX Xavier, Jetson TX1, Jetson Nano

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

$ ./installROS.sh -p ros-melodic-desktop -p ros-melodic-rgbd-launch

This script installs a baseline ROS environment. There are several tasks:

<ul>
<li>Enable repositories universe, multiverse, and restricted</li>
<li>Adds the ROS sources list</li>
<li>Sets the needed keys</li>
<li>Loads specified ROS packages, defaults to ros-melodic-base-ros if none specified</li>
<li>Initializes rosdep</li>
</ul>

You can edit this file to add the ROS packages for your application. 

<strong>setupCatkinWorkspace.sh</strong>
Usage:

$ ./setupCatkinWorkspace.sh [optionalWorkspaceName]

where optionalWorkspaceName is the name of the workspace to be used. The default workspace name is catkin_ws. This script also sets up some ROS environment variables. Refer to the script for details.

<em><b>Note:</b> On June 7, 2019 the GPG key for ROS was changed due to security issues. If you have ROS installed on your system before this, you should delete the GPG key:</em>
 
<pre>
$ sudo apt-key del 421C365BD9FF1F717815A3895523BAEEB01FA116
</pre> 


## Release Notes
<strong>January 2020</strong>
* v1.0
* Tested on L4T 32.3.1 (JetPack 4.3)

## License
MIT License

Copyright (c) 2017-2020 JetsonHacks

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
 
