terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}


resource "github_actions_environment_secret" "these" {
  for_each = toset(var.secrets)

  repository  = var.repository
  environment = var.environment
  secret_name = each.value
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
