# Provision Role is always beeing created when provisioning a docker-core, even tho its managed by terraform and exists?! 

# Provision real world core devices 
## Store Access Key and Secret of Greengrass-Provision-User in AWS parameter store using terraform
## Create device-installer-script.sh/ansible playbook:
    * assure JVM exist
    * fetch credentials from secret manager and provision core-device
    * assure core device JAR starts with device
## Create ARM based ISO running the script/playbook on first startup or some other process 