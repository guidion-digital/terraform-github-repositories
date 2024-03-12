run "repositories" {
  module {
    source = "./examples/test_app"
  }

  command = plan

  assert {
    condition     = module.unicorns_repos.environments.super-repo.secrets.acc.variables.TFC_APPROVERS.environment == "acc"
    error_message = "The 'acc' environment variable wasn't set"
  }

  assert {
    condition     = keys(module.unicorns_repos.repositories) == ["super-repo"]
    error_message = "The 'super-repo' wasn't created'"
  }
}
