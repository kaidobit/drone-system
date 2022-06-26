ARDUPILOT_PATH=~/ws/drone/ardupilot
VEHICLE=ArduCopter
CATKIN_WORKSPACE=~/ws/drone/catkin_workspace
MODEL=runway

world:
	roslaunch iq_sim ${MODEL}.launch

sim:
	cd $(ARDUPILOT_PATH)/${VEHICLE} && sim_vehicle.py -v ${VEHICLE} -f gazebo-iris --console

vehicle:
	cd $(ARDUPILOT_PATH)/${VEHICLE} && sim_vehicle.py -w

gg-role-arn:
	aws iam get-role --role-name ${GREENGRASS_PROVISION_ROLE} | jq '."Role"."Arn"'

assume-role:
	aws sts assume-role \
    	  --role-arn ${ARN} \
    	  --role-session-name ${GREENGRASS_SESSION_NAME}
