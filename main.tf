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
  auto_init              = each.value.auto_init
  archived               = each.value.archived
  archive_on_destroy     = each.value.archive_on_destroy

  # If it's a private repository, and we're on an enterprise plan, we can explicitly
  # set 'advanced_security'
  dynamic "security_and_analysis" {
    for_each = each.value.visibility == "private" && var.advanced_security ? { "enabled" = true } : {}

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
  depends_on = [github_repository.these]
  for_each   = github_repository.these

  source = "./modules/teams"

  repository    = each.value.name
  teams_info    = lookup(var.repositories, each.value.name, null).teams
  collaborators = lookup(var.repositories, each.value.name, null).collaborators
}

module "environments" {
  depends_on = [github_repository.these]
  for_each   = github_repository.these

  source = "./modules/environments"

  repository              = each.value.name
  environments            = lookup(var.repositories, each.value.name, null).environments
  paid_features_available = var.plan != "free" || lookup(var.repositories, each.value.name, null).visibility == "public" ? true : false
  plan                    = var.plan
}

module "branches" {
  depends_on = [module.environments, github_repository.these]
  for_each   = github_repository.these

  source = "./modules/branches"

  repository              = each.value.name
  default_branch          = lookup(var.repositories, each.value.name, null).default_branch
  branch_protections      = lookup(var.repositories, each.value.name, null).branch_protections
  protected_tags          = lookup(var.repositories, each.value.name, null).protected_tags
  paid_features_available = var.plan != "free" || lookup(var.repositories, each.value.name, null).visibility == "public" ? true : false
}
