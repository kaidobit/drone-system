ARDUPILOT_PATH=~/ws/drone/ardupilot
VEHICLE=ArduCopter
CATKIN_WORKSPACE=~/ws/drone/catkin_workspace
MODEL=runway

launch:
	roslaunch iq_sim ${MODEL}.launch

sim:
	cd $(ARDUPILOT_PATH)/${VEHICLE} && sim_vehicle.py -v ${VEHICLE} -f gazebo-iris --console 

sitl-params:
	cd $(ARDUPILOT_PATH)/${VEHICLE} && sim_vehicle.py -w
