variable "plan" {
  description = "Not all features can be used on all plans"
  type        = string
  default     = "free"

  validation {
    condition     = contains(["free", "teams", "enterprise"], var.plan)
    error_message = "Must be either 'free', 'teams', or 'enterprise'"
  }
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
    has_issues             = Set to true to enable the GitHub Issues features on the repository
    has_projects           = Set to true to enable the GitHub Projects features on the repository. Per the GitHub documentation when in an organization that has disabled repository projects it will default to false and will otherwise default to true. If you specify true when it has been disabled it will return an error
    has_wiki               = Set to true to enable the GitHub Wiki features on the repository
    is_template            = Set to true to tell GitHub that this is a template repository
    vulnerability_alerts   = Set to true to enable security alerts for vulnerable dependencies. Enabling requires alerts to be enabled on the owner level

    security = {
      advanced                        = Whether advanced security is enabled. Has no effect on public repositories, or private repositories with an enterprise plan
      secret_scanning                 = Whether to scan secrets
      secret_scanning_push_protection = Whether to prevent secrets from being pushed
    }

    visibility         = 'public' or 'private'
    protected_branches = List of branches that are to be protected with opinionated rules
    protected_tags     = List of tags that are to be protected with opinionated rules

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
      secrets           = List of names of secrets to create. Does not handle value population
      variables         = Map of variable name to values
      protects_branches = List of branches protected by this environment (deployment needs to pass)
      allowed_branches = List of branches allowed access to this environment
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
    has_issues             = optional(bool, false)
    has_projects           = optional(bool, false)
    has_wiki               = optional(bool, false)
    is_template            = optional(bool, false)
    vulnerability_alerts   = optional(bool, false)
    security = optional(object({
      advanced                        = optional(string, "enabled")
      secret_scanning                 = optional(string, "enabled")
      secret_scanning_push_protection = optional(string, "enabled")
    }), {})
    visibility         = optional(string, "private")
    protected_branches = optional(list(string), ["master", "main", "acc", "develop", "release", "dev", "prod"])
    protected_tags     = optional(list(string), ["releases/**"])
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
      secrets           = optional(list(string), [])
      variables         = optional(map(string), {})
      protects_branches = optional(list(string), []),
      allowed_branches  = optional(list(string), []),
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
