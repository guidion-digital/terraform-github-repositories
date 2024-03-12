terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.0.0"
    }
  }
}

resource "github_repository_environment" "these" {
  for_each = var.environments

  environment = each.key
  repository  = var.repository

  dynamic "reviewers" {
    for_each = var.plan == "teams" || var.plan == "enterprise" || var.visibility == "public" ? { "enabled" = true } : {}

    content {
      teams = each.value.reviewers.teams
      users = each.value.reviewers.users
    }
  }

  deployment_branch_policy {
    protected_branches     = true
    custom_branch_policies = var.visibility == "public" ? true : false
  }
}

resource "github_repository_deployment_branch_policy" "these" {
  for_each = var.visibility == "public" ? github_repository_environment.these : {}

  repository       = var.repository
  environment_name = each.key
  name             = each.value.protected_pattern
}

module "secrets" {
  for_each = var.environments

  source = "./secrets"

  repository  = var.repository
  environment = each.key
  secrets     = each.value.secrets
  variables   = each.value.variables
}

output "secrets" {
  value = module.secrets
}
