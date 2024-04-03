variable "repository" {
  description = "Repository name"
  type        = string
}

variable "environment" {
  description = "Name of environment"
  type        = string
}

variable "protections" {
  description = "Information to create ruleset for"

  type = object({
    protected_branches = optional(list(string), []),
    needs_environments = optional(list(string), [])
  })
}
