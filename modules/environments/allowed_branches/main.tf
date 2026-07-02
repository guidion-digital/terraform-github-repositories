terraform {
  required_providers {
    github = {
      source = "integrations/github"
    }
  }
}

resource "github_repository_environment_deployment_policy" "this" {
  for_each = toset(var.allowed_branches)

  repository     = var.repository
  environment    = var.environment
  branch_pattern = each.value
}
