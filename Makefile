ARDUPILOT_PATH=~/ws/drone/ardupilot
VEHICLE=ArduCopter

first-sim:
	cd $(ARDUPILOT_PATH)/${VEHICLE} && sim_vehicle.py -v ${VEHICLE} --console --map -c

sim:
	cd $(ARDUPILOT_PATH)/${VEHICLE} && sim_vehicle.py -v ${VEHICLE} --console --map -N #-f gazebo-iris

gg-install:
	sh ./bin/scripts/gg-install.sh

gg-logs:
	tail -f ./bin/greengrass/v2/logs/greengrass.log

gg-uninstall:
	rm -rf ./bin/greengrass/v2 && \
	rm -rf ./bin/greengrass/GreengrassInstaller && \
	systemctl stop greengrass.service && \
	systemctl disable greengrass.service && \
	rm /etc/systemd/system/greengrass.service && \
	systemctl daemon-reload