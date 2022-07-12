#!/bin/bash
curl -s https://d2s8p88vqu9w66.cloudfront.net/releases/greengrass-nucleus-latest.zip > greengrass-nucleus-latest.zip
unzip greengrass-nucleus-latest.zip -d ./bin/greengrass/GreengrassInstaller
rm greengrass-nucleus-latest.zip
java -Droot="./bin/greengrass/v2" -Dlog.store=FILE \
    -jar ./bin/greengrass/GreengrassInstaller/lib/Greengrass.jar \
    --aws-region ${AWS_REGION} \
    --thing-name ${GREENGRASS_CORE_THING_NAME} \
    --thing-group-name ${IOT_DEVELOPMENT_THING_GROUP_NAME} \
    --thing-policy-name ${IOT_THING_POLICY_NAME} \
    --tes-role-name ${GREENGRASS_PROVISION_ROLE_NAME} \
    --tes-role-alias-name ${GREENGRASS_PROVISION_ROLE_ALIAS} \
    --component-default-user ggc_user:ggc_group \
    --provision true \
    --setup-system-service true