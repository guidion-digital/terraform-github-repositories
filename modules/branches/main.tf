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
  for_each = var.paid_features_available ? var.branch_protections : {}

  pattern       = each.key
  repository_id = var.repository

  enforce_admins                  = each.value.enforce_admins
  require_signed_commits          = each.value.require_signed_commits
  required_linear_history         = each.value.required_linear_history
  require_conversation_resolution = each.value.require_conversation_resolution
  force_push_bypassers            = each.value.force_push_bypassers
  allows_deletions                = each.value.allows_deletions
  allows_force_pushes             = each.value.allows_force_pushes
  lock_branch                     = each.value.lock_branch

  dynamic "required_status_checks" {
    for_each = each.value.required_status_checks != null ? { enabled = 1 } : {}

    content {
      strict   = each.value.required_status_checks.strict
      contexts = each.value.required_status_checks.contexts
    }
  }

  dynamic "required_pull_request_reviews" {
    for_each = each.value.required_pull_request_reviews != null ? { enabled = 1 } : {}

    content {
      required_approving_review_count = each.value.required_pull_request_reviews.required_approving_review_count
      dismiss_stale_reviews           = each.value.required_pull_request_reviews.dismiss_stale_reviews
      restrict_dismissals             = each.value.required_pull_request_reviews.restrict_dismissals
      dismissal_restrictions          = each.value.required_pull_request_reviews.dismissal_restrictions
      pull_request_bypassers          = each.value.required_pull_request_reviews.pull_request_bypassers
      require_code_owner_reviews      = each.value.required_pull_request_reviews.require_code_owner_reviews
      require_last_push_approval      = each.value.required_pull_request_reviews.require_last_push_approval
    }
  }

  dynamic "restrict_pushes" {
    for_each = each.value.restrict_pushes != null ? { enabled = 1 } : {}

    content {
      blocks_creations = each.value.restrict_pushes.blocks_creations
      push_allowances  = each.value.restrict_pushes.push_allowances
    }
  }
}

resource "github_repository_tag_protection" "these" {
  for_each = var.paid_features_available ? toset(var.protected_tags) : toset([])

  repository = var.repository
  pattern    = each.value
}
