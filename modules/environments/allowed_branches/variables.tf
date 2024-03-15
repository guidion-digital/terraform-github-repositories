variable "allowed_branches" {
  description = "Branches to allow to the environment"
  type        = list(string)
}

variable "environment" {
  description = "Environment name we're protecting"
  type        = string
}

variable "repository" {
  description = "Name of repository the environment resides in"
  type        = string
}
