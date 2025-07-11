output "environments" {
  value = module.environments
}

output "repositories" {
  value = { for this_repo in github_repository.these : this_repo.name => this_repo.id }
}

output "repository_ids" {
  value = { for this_repo in github_repository.these : this_repo.name => this_repo.repo_id }
}
