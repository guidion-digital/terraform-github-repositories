variable "repository" {
  description = "The repository name"
}

variable "environments" {
  description = "Configuration for environments in this repository"

  type = map(object({
    secrets          = optional(list(string), [])
    variables        = optional(map(string), {})
    allowed_branches = optional(list(string), [])
    protections = optional(object({
      protected_branches = list(string)
      needs_environments = list(string)
    }))
    reviewers = optional(object({
      teams = optional(list(number), [])
      users = optional(list(number), [])
      }), {
      teams = []
      users = []
    })
    wait_timer          = optional(string),
    can_admins_bypass   = optional(bool, true),
    prevent_self_review = optional(bool, false)
  }))
}

variable "paid_features_available" {
  description = "Not all features are available to private repos without paying"
  type        = bool
  default     = false
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
