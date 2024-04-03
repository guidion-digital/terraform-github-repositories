terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.0.0"
    }
  }
}

resource "github_repository_ruleset" "these" {
  # If there are any non-null values in 'protected_branches' or
  # 'needs_environments', then we will create a ruleset
  count = length(distinct(values(var.protections))) > 1 ? 1 : 0

  name        = var.environment
  repository  = var.repository
  target      = "branch"
  enforcement = "disabled" # TODO: This is a work in progress

  dynamic "conditions" {
    for_each = var.protections.protected_branches != null ? [var.protections.protected_branches] : [[var.environment]]

    content {
      ref_name {
        include = [for this_condition in conditions.value : "refs/heads/${this_condition}"]
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
      required_deployment_environments = var.protections.needs_environments
    }
  }
}
