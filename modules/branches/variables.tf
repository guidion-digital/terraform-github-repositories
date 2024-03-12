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

variable "visibility" {
  description = "Public or private?"
  type        = string
}

variable "plan" {
  description = "Not all features can be used on all plans"
  type        = string
  default     = "free"

  validation {
    condition     = contains(["free", "teams", "enterprise"], var.plan)
    error_message = "Must be either 'free', 'teams', or 'enterprise'"
  }
}
