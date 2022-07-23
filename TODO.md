# terraform
## erstelle components
### .envrc pro component mit, die $VERSION exportiert
### $VERSION in recipe.yaml verwenden
### $VERSION in terraform für deployment anpassen 
## deployment nucleus, cli, localdebug, alle components auf device group

# custom core-device-docker-image
## aws-creds als envs
## zusätzliche portweiterleitung für debug webui
## log von greengrass

# dockerize sim_vehicle.py

# Provision real world core devices 
## Store Access Key and Secret of Greengrass-Provision-User in AWS parameter store using terraform
## Create device-installer-script.sh/ansible playbook:
    * assure JVM exist
    * fetch credentials from secret manager and provision core-device
    * assure core device JAR starts with device
## Create ARM based ISO running the script/playbook on first startup or some other process 