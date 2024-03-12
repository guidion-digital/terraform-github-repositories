resource "github_repository" "these" {
  for_each = var.repositories

  name                   = each.key
  description            = each.value.description
  homepage_url           = each.value.homepage_url
  visibility             = each.value.visibility
  delete_branch_on_merge = each.value.delete_branch_on_merge
  allow_update_branch    = each.value.allow_update_branch
  has_discussions        = each.value.has_discussions
  has_downloads          = each.value.has_downloads
  has_issues             = each.value.has_issues
  has_projects           = each.value.has_projects
  has_wiki               = each.value.has_wiki
  is_template            = each.value.is_template
  vulnerability_alerts   = each.value.vulnerability_alerts

  # If it's a private repository, and we're on an enterprise plan, we can explicitly
  # set 'advanced_security'
  dynamic "security_and_analysis" {
    for_each = each.value.visibility == "private" && var.plan == "enterprise" ? { "enabled" = true } : {}

    content {
      advanced_security { status = each.value.security.advanced }
      secret_scanning { status = each.value.security.secret_scanning }
      secret_scanning_push_protection { status = each.value.security.secret_scanning_push_protection }
    }
  }

  # We have to set this seperately for public repositories because of this bug:
  # Bug: https://github.com/integrations/terraform-provider-github/issues/2190
  #
  # If it's a public repository, we can't explicitly set 'advanced_security'
  dynamic "security_and_analysis" {
    for_each = each.value.visibility == "public" ? { "enabled" = true } : {}

    content {
      secret_scanning { status = each.value.security.secret_scanning }
      secret_scanning_push_protection { status = each.value.security.secret_scanning_push_protection }
    }
  }
}

module "teams" {
  for_each = github_repository.these

  source = "./modules/teams"

  repository = each.value.name
  teams_info = lookup(var.repositories, each.value.name).teams
}

module "environments" {
  for_each = github_repository.these

  source = "./modules/environments"

  repository   = each.value.name
  environments = lookup(var.repositories, each.value.name).environments
  visibility   = lookup(var.repositories, each.value.name).visibility
}

module "branches" {
  depends_on = [module.environments]
  for_each   = github_repository.these

  source       = "./modules/branches"
  repository   = each.value.name
  branches     = lookup(var.repositories, each.value.name).protected_branches
  environments = lookup(var.repositories, each.value.name).environments
}
