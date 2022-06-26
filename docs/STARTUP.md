# Setup

## Requirements
* make sure you read the SYSTEM_REQUIREMENTS.md

## Terraform Bootstrap
TBD...

## Project

1. Optionally configure the .envrc.
2. Provision the Infrastructure:
   ```
   aws-vault exec <YOUR_PROFILENAME> -- terraform apply
   ```
confirm by entering yes.

3. Add your IAM user to the `$PROJECTNAME-developer` group created by step 1.

4. Provision your Greengrass-Core device:
   1. Get the Role ARN for the Greengrass Provisioning Role:
      ```
      aws-vault exec <YOUR_PROFILENAME> -- make gg-role-arn
      ```
      Add it into your aws-vault config. 
   2. Get you Access Key ID, Secret Access Key and Session Token using the newly created profile (we only need those during provisioning):
      ```
      aws-vault exec <PROVISION_ROLE_PROFILENAME> -- env | grep -E 'AWS_ACCESS_KEY_ID|AWS_SECRET_ACCESS_KEY|AWS_SESSION_TOKEN'
      ```
   3. Create `volumes/greengrass-core/credentials`, which will be used by greengrass-core in order to provision:
      ```
      [default]
      aws_access_key_id = <AWS_ACCESS_KEY_ID>
      aws_secret_access_key = <AWS_SECRET_ACCESS_KEY>
      aws_session_token = <AWS_SESSION_TOKEN>
      ```
   4. Start it by running `docker-compose up -d greengrass-core`, it will provision automatically and it registeres with AWS IoT Greengrass and you can view it in the console/cli. 
   5. Delete `volumes/greengrass-core/credentials`.

