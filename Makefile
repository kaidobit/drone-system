ARDUPILOT_PATH=~/ws/drone/ardupilot
VEHICLE=ArduCopter

first-sim:
	cd $(ARDUPILOT_PATH)/${VEHICLE} && sim_vehicle.py -v ${VEHICLE} --console --map -c

sim:
	cd $(ARDUPILOT_PATH)/${VEHICLE} && sim_vehicle.py -v ${VEHICLE} --console --map -N #-f gazebo-iris

cc-logs:
	docker-compose exec companion-computer tail -f /greengrass/v2/logs/greengrass.log