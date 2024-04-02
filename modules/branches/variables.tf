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
  description = "Only these two keys from parent"

  type = map(object({
    protects_branches  = list(string)
    needs_environments = list(string)
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
  protected_branches = var.default_branch != null && length(var.protected_branches) != 0 ? (contains(var.protected_branches, var.default_branch) == false ? concat(var.protected_branches, [var.default_branch]) : var.protected_branches) : var.protected_branches
}
