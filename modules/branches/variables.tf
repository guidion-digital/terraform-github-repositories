variable "repository" {
  description = "Name of the repository"
  type        = string
}

variable "protected_branches" {
  description = "List of the protected branch names to configure"
  type        = list(string)
}

variable "protected_tags" {
  description = "List of the protected tags to configure"
  type        = list(string)
}

variable "environments" {
  description = "Only needs protects_branches list from parent"

  type = map(object({
    protects_branches = list(string)
  }))
}

variable "paid_features_available" {
  description = "Not all features are available to private repos without paying"
  type        = bool
  default     = false
}

variable "default_branch" {
  description = "Branch to make PRs against by default"
  type        = string

  default = null
}

locals {
  protected_branches = (contains(var.protected_branches, var.default_branch) == false ? concat(var.protected_branches, [var.default_branch]) : var.protected_branches)
}
