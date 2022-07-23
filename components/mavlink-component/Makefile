.PHONY: help

help:           	## show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

gen-reqs:			## generate requirements.txt
	poetry export -o requirements.txt --without-hashes

artifact: gen-reqs	## creates a uploadable zip which in return can be deployed on a greengrass-core device
	zip -rj \
		${COMPONENT_NAME}.zip \
		mavlink_component/* \
		requirements.txt

publish: artifact	## (req. aws creds) uploads artifact into s3 using version from .envrc and then cleans
	aws s3 cp ${COMPONENT_NAME}.zip s3://drone-system-artifact-origin/io.shaikh.${COMPONENT_NAME}/${VERSION}/${COMPONENT_NAME}.zip ; \
	make clean

clean:				## clean this directory
	rm requirements.txt
	rm ${COMPONENT_NAME}.zip

local-deploy:		## deploy locally, only for development purpose
	../../bin/greengrass/v2/bin/greengrass-cli deployment create -r . -a . -m "io.shaikh.${COMPONENT_NAME}=${VERSION}"