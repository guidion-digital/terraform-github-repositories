variable "repository" {
  description = "Name of the repository"
  type        = string
}

variable "environment" {
  description = "Name of the environment to create"
  type        = string
}

variable "variables" {
  description = "Map of key/values for variables"
  type        = map(string)
}
