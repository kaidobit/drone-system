zip:
	rm ${COMPONENT_NAME}.zip
	poetry export -o requirements.txt --without-hashes
	zip -rj \
		${COMPONENT_NAME}.zip \
		mavlink_component/* \
		requirements.txt
	rm requirements.txt


upload:
	aws s3 cp ${COMPONENT_NAME}.zip s3://drone-system-artifact-origin/io.shaikh.${COMPONENT_NAME}/${VERSION}/${COMPONENT_NAME}.zip

ldeploy:
	../../bin/greengrass/v2/bin/greengrass-cli deployment create -r . -a . -m "io.shaikh.${COMPONENT_NAME}=${VERSION}"