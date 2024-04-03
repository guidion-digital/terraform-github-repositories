# Variables go here:
variable "plan" {}

# Fixtures
resource "github_team" "unicorns" {
  name                      = "unicorns"
  description               = "We do the webs"
  privacy                   = "closed"
  create_default_maintainer = true
}

# Test example
module "unicorns_repos" {
  source = "../../"

  plan = var.plan

  repositories = {
    "super-repo" = {
      description  = "We're going to change the world"
      homepage_url = "https://example.com"
      visibility   = "private"

      enforce_admins                  = true
      require_signed_commits          = true
      required_linear_history         = false
      require_conversation_resolution = true
      required_status_checks = {
        strict   = true
        contexts = []
      }
      required_pull_request_reviews = {
        required_approving_review_count = 2
        dismiss_stale_reviews           = false
      }
      restrict_pushes = {
        blocks_creations = false
        push_allowances  = []
      }
      force_push_bypassers = []
      allows_deletions     = true
      allows_force_pushes  = false
      lock_branch          = true

      environments = {
        acc = {
          secrets = ["npmrc"]
          variables = {
            "TFC_APPROVERS" = "afrazkhan"
          }

          protections = {
            protected_branches = ["acc"]
            needs_environments = ["dev"]
          }

          reviewers = {
            teams = [github_team.unicorns.id]
          }
        }
      }

      teams = {
        "unicorns" = {
          id         = github_team.unicorns.id
          permission = "pull"
        }
      }
    }
  }
}
