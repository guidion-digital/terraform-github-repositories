terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

resource "github_repository_environment" "these" {
  for_each = var.environments

  environment         = each.key
  repository          = var.repository
  wait_timer          = each.value.wait_timer
  can_admins_bypass   = each.value.can_admins_bypass
  prevent_self_review = each.value.prevent_self_review

  dynamic "reviewers" {
    for_each = var.plan == "enterprise" && (each.value.reviewers.teams != null || each.value.reviewers.users != null) ? { "enabled" = true } : {}

    content {
      teams = each.value.reviewers.teams
      users = each.value.reviewers.users
    }
  }

  deployment_branch_policy {
    protected_branches     = var.paid_features_available ? false : true
    custom_branch_policies = var.paid_features_available ? true : false
  }
}

module "allowed_branches" {
  depends_on = [github_repository_environment.these]
  source     = "./allowed_branches"
  for_each   = var.paid_features_available ? { for this_environment, these_values in var.environments : this_environment => these_values if try(these_values.allowed_branches, null) != null } : {}

  repository       = var.repository
  environment      = each.key
  allowed_branches = each.value.allowed_branches
}

module "secrets" {
  depends_on = [github_repository_environment.these]
  for_each   = var.environments

  source = "./secrets"

  repository  = var.repository
  environment = each.key
  secrets     = each.value.secrets
  variables   = each.value.variables
}

module "environment_rulesets" {
  source = "./environment_rulesets"

  for_each = var.environments

  repository  = var.repository
  environment = each.key
  protections = each.value.protections
}
