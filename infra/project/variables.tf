variable "projectname" {
  type = string
}

variable "iam_force_destroy_provision_user" {
  type = bool
}

variable "greengrass_provision_role_name" {
  type = string
}

variable "greengrass_provision_policy_name" {
  type = string
}

variable "s3_destroy_artifact_origin" {
  type = bool
}