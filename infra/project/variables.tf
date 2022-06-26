variable "projectname" {
  type        = string
  description = "This is the project's name."
}

variable "greengrass_v2_token_exchange_role_name" {
  type        = string
  description = "This is the role assumed for provisioning core devices."
}

variable "force_destroy_stack" {
  type        = bool
  default     = true
}

