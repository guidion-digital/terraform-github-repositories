variable "repository" {
  description = "Name of the repository"
  type        = string
}

variable "environment" {
  description = "Name of the environment to create"
  type        = string
}

variable "secrets" {
  description = "List of secret names. This module does not support setting values for secrets"
  type        = list(string)
}

variable "variables" {
  description = "Map of key/values for variables"
  type        = map(string)
}
