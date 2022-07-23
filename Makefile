ARDUPILOT_PATH=~/ws/drone/ardupilot
VEHICLE=ArduCopter

.PHONY: help

help:           ## show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

sim:			## start vehicle simulation (no rebuild)
	cd $(ARDUPILOT_PATH)/${VEHICLE} && sim_vehicle.py -v ${VEHICLE} --console --map -N

gg-install:		## (req. aws creds + root priv) install greengrass-core in bin/
	sh ./bin/scripts/gg-install.sh

gg-logs:		## (req. root priv) follow greengrass-core logs
	tail -f ./bin/greengrass/v2/logs/greengrass.log

gg-pw:			## (req. root priv) get password for web based local debug console
	./bin/greengrass/v2/bin/greengrass-cli get-debug-password

gg-uninstall:	## (req. root priv) uninstall greengrass-core
	rm -rf ./bin/greengrass/v2 && \
	rm -rf ./bin/greengrass/GreengrassInstaller && \
	systemctl stop greengrass.service && \
	systemctl disable greengrass.service && \
	rm /etc/systemd/system/greengrass.service && \
	systemctl daemon-reload