terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.0.0"
    }
  }
}

resource "github_team_repository" "these" {
  for_each = var.teams_info

  repository = var.repository
  team_id    = each.value.id
  permission = each.value.permission
}
