ARDUPILOT_PATH=~/ws/drone/ardupilot
VEHICLE=ArduCopter

first-sim:
	cd $(ARDUPILOT_PATH)/${VEHICLE} && sim_vehicle.py -v ${VEHICLE} --console --map -c

sim:
	cd $(ARDUPILOT_PATH)/${VEHICLE} && sim_vehicle.py -v ${VEHICLE} --console --map -N #-f gazebo-iris

gg-role-arn:
	aws iam get-role --role-name ${GREENGRASS_PROVISION_ROLE} | jq '."Role"."Arn"'

assume-role:
	aws sts assume-role \
    	  --role-arn ${ARN} \
    	  --role-session-name ${GREENGRASS_SESSION_NAME}

gg-logs:
	docker-compose exec greengrass-core tail -f /greengrass/v2/logs/greengrass.log