variable "projectname" {
  type        = string
  description = "This is the project's name."
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

variable "force_destroy_stack" {
  type        = bool
  default     = true
}

