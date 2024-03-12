variable "repository" {
  description = "Name of the repository"
  type        = string
}

variable "branches" {
  description = "List of the protected branch names to configure"
  type        = list(string)
}

variable "environments" {
  description = "Only needs protects_branches list from parent"

  type = map(object({
    protects_branches = list(string)
  }))
}
