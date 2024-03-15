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

      environments = {
        acc = {
          protects_branches = ["master", "prod"]
          secrets           = ["npmrc"]
          variables = {
            "TFC_APPROVERS" = "afrazkhan"
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
