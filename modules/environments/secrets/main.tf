terraform {
  required_providers {
    github = {
      source = "integrations/github"
    }
  }
}

resource "github_actions_environment_variable" "these" {
  for_each = var.variables

  repository    = var.repository
  environment   = var.environment
  variable_name = each.key
  value         = each.value
}

output "variables" {
  description = "Secrets created by this module"
  value       = github_actions_environment_variable.these
}
