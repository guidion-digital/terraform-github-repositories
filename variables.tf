variable "plan" {
  description = "Not all features can be used on all plans"
  type        = string
  default     = "free"

  validation {
    condition     = contains(["free", "teams", "enterprise"], var.plan)
    error_message = "Must be either 'free', 'teams', or 'enterprise'"
  }
}

variable "advanced_security" {
  description = "Whether advanced security has been purchased"
  type        = bool
  default     = false
}

variable "repositories" {
  description = <<EOF
Defines a repo in full. Map of the following object:

    description            = Optional short repository description
    homepage_url           = Optional URL for this repo
    delete_branch_on_merge = Whether to delete merged branches
    allow_update_branch    = Set to true to always suggest updating pull request branches
    has_discussions        = Set to true to enable GitHub Discussions on the repository. Defaults to false
    has_downloads          = Set to true to enable the (deprecated) downloads features on the repository
    has_issues             = Set to false to disable the GitHub Issues features on the repository
    has_projects           = Set to true to enable the GitHub Projects features on the repository. Per the GitHub documentation when in an organization that has disabled repository projects it will default to false and will otherwise default to true. If you specify true when it has been disabled it will return an error
    has_wiki               = Set to true to enable the GitHub Wiki features on the repository
    is_template            = Set to true to tell GitHub that this is a template repository
    vulnerability_alerts   = Set to true to enable security alerts for vulnerable dependencies. Enabling requires alerts to be enabled on the owner level
    default_branch         = Branch to make PRs against by default (must already exist if set, so can not be used when creating repository)

    security = {
      advanced                        = Whether advanced security is enabled. Has no effect on public repositories, or private repositories without an advanced security purchase
      secret_scanning                 = Whether to scan secrets
      secret_scanning_push_protection = Whether to prevent secrets from being pushed
    }

    visibility         = 'public' or 'private'
    protected_tags     = List of tags that are to be protected with opinionated rules

    branch_protections = Map of branch protections and their settings.
                         See here for specification: https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_protection#argument-reference
                         N.B. Block and all attributes are optional, but if any
                         value is given, then the other attributes are filled
                         in by their defaults, which you can find in the variable
                         definition

    collaborators = Map of {
      username                    = Github username
      permission                  = Permission to give username
      permission_diff_suppression = Suppress plan diffs for triage and maintain
    }

    teams = Map of {
      id         = Team ID
      permission = Corresponds to UI names in this order: 'pull', 'triage', 'push', 'maintain', 'admin'
    }

    environments = Map of {
      secrets            = List of names of secrets to create. Does not handle value population
      variables          = Map of variable name to values
      allowed_branches   = List of branches allowed access to this environment
      needs_environments = (WIP) List of environments that need to have been deployed before this one can be
      protections = Creates a ruleset if provided:
        {
          protected_branches = List of branches that will be protected in a ruleset
          needs_environments = List of environments that need to have been deployed in order to update 'protected_branchs'
        }
      reviewers = {
        teams = List of team reviewers
        users = List of individual user reviewers
        }
    }
  }
EOF

  type = map(object({
    description            = optional(string, "")
    homepage_url           = optional(string, "")
    delete_branch_on_merge = optional(bool, true)
    allow_update_branch    = optional(bool, false)
    has_discussions        = optional(bool, false)
    has_downloads          = optional(bool, false)
    has_issues             = optional(bool, true)
    has_projects           = optional(bool, false)
    has_wiki               = optional(bool, false)
    is_template            = optional(bool, false)
    vulnerability_alerts   = optional(bool, false)
    default_branch         = optional(string, null)
    security = optional(object({
      advanced                        = optional(string, "enabled")
      secret_scanning                 = optional(string, "enabled")
      secret_scanning_push_protection = optional(string, "enabled")
    }), {})
    visibility = optional(string, "private")

    branch_protections = optional(map(object({
      enforce_admins                  = optional(bool, false)
      require_signed_commits          = optional(bool, false)
      required_linear_history         = optional(bool, false)
      require_conversation_resolution = optional(bool, false)
      required_status_checks = optional(object({
        strict   = optional(bool, false)
        contexts = optional(list(string), [])
      }), null)
      required_pull_request_reviews = optional(object({
        dismiss_stale_reviews           = optional(bool, true)
        restrict_dismissals             = optional(bool, false)
        dismissal_restrictions          = optional(list(string), [])
        pull_request_bypassers          = optional(list(string), [])
        require_code_owner_reviews      = optional(bool, false)
        required_approving_review_count = optional(number, 1)
        require_last_push_approval      = optional(bool, false)
      }), null)
      restrict_pushes = optional(object({
        blocks_creations = optional(bool, true)
        push_allowances  = optional(list(string), [])
      }), null)
      force_push_bypassers = optional(list(string), [])
      allows_deletions     = optional(bool, false)
      allows_force_pushes  = optional(bool, false)
      lock_branch          = optional(bool, false)
    })), {})


    protected_tags = optional(list(string), ["releases/**"])
    collaborators = optional(map(object({
      username                    = string,
      permission                  = optional(string, "pull")
      permission_diff_suppression = optional(bool, false)
    })), {})
    teams = optional(map(object({
      id         = number
      permission = optional(string, "push")
    })), {})
    environments = optional(map(object({
      secrets   = optional(list(string), [])
      variables = optional(map(string), {})
      protections = optional(object({
        protected_branches = optional(list(string), []),
        needs_environments = optional(list(string), [])
        }), {
        protected_branches = [],
        needs_environments = []
      }),
      allowed_branches = optional(list(string), []),
      reviewers = optional(object({
        teams = optional(list(number), [])
        users = optional(list(number), [])
        }), {
        teams = []
        users = []
      })
    })), {})
  }))
}
