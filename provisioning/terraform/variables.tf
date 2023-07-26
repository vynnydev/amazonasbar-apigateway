variable "region" {
  type    = string
  default = "us-east-1"
}

variable "stack_prefix" {
  type    = string
}

variable "use_permissions_boundary" {
  type = bool
  description = "Whether use a permission boundary while creating an IAM role?"
  default = false
}

variable "permissions_boundary_policy" {
  type        = string
  description = "Permissions boundary policy to be used for the role creation"
  default = null
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "application" {
  type    = string
  default = "amazonasbar"
}