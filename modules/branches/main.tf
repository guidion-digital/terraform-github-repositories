terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.0.0"
    }
  }
}

resource "github_branch_default" "default" {
  count = var.default_branch != null ? 1 : 0

  repository = var.repository
  branch     = var.default_branch
}

resource "github_branch_protection" "this" {
  for_each = var.paid_features_available ? toset(local.protected_branches) : toset([])

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
  for_each = var.paid_features_available ? toset(var.protected_tags) : toset([])

  repository = var.repository
  pattern    = each.value
}
