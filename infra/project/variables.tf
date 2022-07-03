variable "projectname" {
  type        = string
  description = "This is the project's name."
}

variable "iam_force_destroy_provision_user" {
  type        = bool
  default     = true
  description = "Destroy Provision user even when it has non-Terraform managed Access Keys."
}

variable "greengrass_v2_token_exchange_role_name" {
  type        = string
  description = "This is the role assumed for provisioning core devices."
}

variable "greengrass_v2_token_exchange_policy_name" {
  type        = string
  description = "This is the name of the provisioning role's policy."
}

variable "greengrass_v2_token_exchange_role_alias" {
  type        = string
  description = "This is the alias for the provisioning, which is used by AWS IoT to leverage other Amazon services."
}

variable "s3_destroy_artifact_origin" {
  type        = bool
  default     = false
  description = "When destroying this Stack should the contents of the artifact bucket be deleted before the bucket is being destroyed."
}

variable "cloudfront_artifact_distribution_aliases" {
  type        = list(string)
  default     = []
  description = "Custom domain names for "
}

variable "cloudfront_enable_artifact_distribution" {
  type        = bool
  default     = false
  description = "Enable/Disable Cloudfront artifact distribution, in order to save some money. This is where devices get their components. (can be enabled manually)"
}

variable "cloudfront_retain_artifact_distribution_on_destroy" {
  type        = bool
  default     = true
  description = "Disable or Destroy Cloudfront artifact Distribution when this stack is being destroyed."
}