terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.0.0"
    }
  }
}

resource "github_branch_protection" "this" {
  for_each = toset(var.branches)

  pattern                = each.key
  repository_id          = var.repository
  enforce_admins         = true
  require_signed_commits = true

  required_pull_request_reviews {
    required_approving_review_count = 1
    dismiss_stale_reviews           = true
  }

  restrict_pushes {
    blocks_creations = true
  }
}

resource "github_repository_tag_protection" "these" {
  count = var.plan != "free" || var.visibility == "public" ? 1 : 0

  repository = var.repository
  pattern    = "releases/**"
}

resource "github_repository_ruleset" "these" {
  for_each = var.environments

  name        = "prod"
  repository  = var.repository
  target      = "branch"
  enforcement = "disabled"

  dynamic "conditions" {
    for_each = each.value.protects_branches != null ? each.value.protects_branches : []

    content {
      ref_name {
        include = ["refs/heads/${conditions.value}"]
        exclude = []
      }
    }
  }

  rules {
    creation            = true
    update              = true
    deletion            = true
    required_signatures = true

    required_deployments {
      required_deployment_environments = [each.key]
    }
  }
}
