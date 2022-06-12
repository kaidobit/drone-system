# drone-system

## Development Setup

### 1. Install Autopilot (Ardupilot)

> We need the code of the autopilot in order to be simulated using SITL.

#### 1.1 Install environment
Get Source:
```
git clone https://github.com/ArduPilot/ardupilot.git
```

Install dependencies:
> Other distros are also supported.
```
cd ardupilot
Tools/environment_install/install-prereqs-ubuntu.sh -y
```

Reload profile due to changes made by previous step:
```
. ~/.profile
```

#### 1.2 Get vehicle build
> Please [check](https://github.com/ArduPilot/ardupilot/tags) which vehicle-build version suits you the best
```
git checkout Copter-<VERSION_OF_YOUR_CHOICE>
git submodule update --init --recursive
```

Run SITL (Software In The Loop) once to set params:
```
make sitl-params
```

### 2. Install Gazebo for Ardupilot

> While we use Ardupilot's SITL to simulate our vehicle. We need Gazebo to simulate our environmental conditions in order to trigger our simulated sensors.


#### 2.1 Gazebo installation

> Make sure to install desktop full version.

Gazebo is installed using the package manager of your distro, I kindly ask you to refer to their [official documentation](https://osrf.github.io/gazebo-doc-index/categories/installing_gazebo.html).

#### 2.2 Install Ardupilot plugin for Gazebo
```
git clone https://github.com/khancyr/ardupilot_gazebo.git
cd ardupilot_gazebo
cmake ..
make -j4
sudo make install
```
Make sure `/usr/share/gazebo/setup.sh` is sourced on every shell.

> `ardupilot_gazebo/models` are outdated. You could create custom Gazebo models for yourself or you keep reading becouse we will come back to this issue.

In case of these models ever beeing updated I suggest you 
```
export GAZEBO_MODEL_PATH=<REPO_DIR-ardupilot_gazebo>/models
```
anyway permanently.

### 3. Install ROS

> ROS or Robot Operating System is a framework for industrial robotik applications. We will use it in order to control a drone over Mavlink using a ground station. For this specific purpose the creators of ROS published Mavros, which is basically what we're dealing with.

#### 3.1 ROS
This is distro specific please refer to the [official documentation](http://wiki.ros.org/Installation)

#### 3.2 Set Up Catkin workspace

> Catkin is a collection of cmake macros and associated python code used to build some parts of ROS.

Install `pip3` and then install python packages>:

```
pip3 install osrf-pycommon, wstool, rosinstall-generator, catkin-lint, catkin-tools
```

Then, initialize the catkin workspace:
```
mkdir -p <YOUR_CATKIN_WORKSPACE>/src
cd <YOUR_CATKIN_WORKSPACE>
catkin init
```

#### 3.3 Install Mavros and Mavlink


```
cd <YOUR_CATKIN_WORKSPACE>
wstool init src
rosinstall_generator --upstream mavros | tee /tmp/mavros.rosinstall
rosinstall_generator mavlink | tee -a /tmp/mavros.rosinstall
wstool merge -t src /tmp/mavros.rosinstall
wstool update -t src
rosdep install --from-paths src --ignore-src --rosdistro `echo $ROS_DISTRO` -y
catkin build
```
Make sure `<YOUR_CATKIN_WORKSPACE>/devel/setup.[bash/zsh/...]` is beeing sourced on each shell.

Install `geographiclib` dependancy 
```
sudo <YOUR_CATKIN_WORKSPACE>/src/mavros/mavros/scripts/install_geographiclib_datasets.sh
```

### 4. Install 3rd party Gazebo models

Download models into src directory in catkin workspace:
```
cd <YOUR_CATKIN_WORKSPACE>/src
git clone https://github.com/Intelligent-Quads/iq_sim.git
```

Add new models to Gazebo's model path:
```
export GAZEBO_MODEL_PATH=${GAZEBO_MODEL_PATH}:$HOME/catkin_ws/src/iq_sim/models
```
Ensure this for each shell.

### 6. Build Catkin workspace
```
cd <YOUR_CATKIN_WORKSPACE>
catkin build
```
### Make everything take effect and run your development environment
Create a new shell and start Gazebo and SITL.

Gazebo:
```
make launch
```
open a second shell and start SITL:
```
make sim
```

A few windows will pop up. Now type the following in the SITL-shell:
```
mode guided
arm throttle
takeoff 10
```
and watch your drone take off to 10 meters height in Gazebo.


## Useful Links
- [SITL](https://ardupilot.org/dev/docs/sitl-simulator-software-in-the-loop.html)
- [Mavlink](https://mavlink.io/en/)
- [Mavros](http://wiki.ros.org/mavros)
- [Catkin](https://github.com/ros/catkin)
- [3rd party Gazebo Models](https://github.com/Intelligent-Quads/iq_sim)