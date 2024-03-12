output "environments" {
  value = module.environments
}

output "repositories" {
  value = { for this_repo in github_repository.these : this_repo.name => this_repo.id }
}
