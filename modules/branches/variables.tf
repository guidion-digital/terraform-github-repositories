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
