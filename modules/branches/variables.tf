variable "repository" {
  description = "Name of the repository"
  type        = string
}

variable "branch_protections" {
  description = "Various options on branch protections. Key is used as the branch name"

  type = map(object({
    enforce_admins                  = optional(bool, false)
    require_signed_commits          = optional(bool, false)
    required_linear_history         = optional(bool, false)
    require_conversation_resolution = optional(bool, false)
    required_status_checks = optional(object({
      strict   = optional(bool, false)
      contexts = optional(list(string))
    }))
    required_pull_request_reviews = optional(object({
      dismiss_stale_reviews           = optional(bool, true)
      restrict_dismissals             = optional(bool, false)
      dismissal_restrictions          = optional(list(string), [])
      pull_request_bypassers          = optional(list(string), [])
      require_code_owner_reviews      = optional(bool, false)
      required_approving_review_count = optional(number, 1)
      require_last_push_approval      = optional(bool, false)
    }))
    restrict_pushes = optional(object({
      blocks_creations = optional(bool, true)
      push_allowances  = optional(list(string))
    }))
    force_push_bypassers = optional(list(string), [])
    allows_deletions     = optional(bool, false)
    allows_force_pushes  = optional(bool, false)
    lock_branch          = optional(bool, false)
  }))
}

variable "protected_tags" {
  description = "WIP: List of the protected tags to configure"
  type        = list(string)
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
