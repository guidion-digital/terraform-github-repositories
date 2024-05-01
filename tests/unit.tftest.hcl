run "free_plan" {
  module {
    source = "./examples/test_app"
  }

  command = plan

  variables {
    plan = "free"
  }

  assert {
    condition     = module.unicorns_repos.environments.super-repo.secrets.acc.variables.TFC_APPROVERS.environment == "acc"
    error_message = "The 'acc' environment variable wasn't set"
  }

  assert {
    condition     = keys(module.unicorns_repos.repositories) == ["super-repo"]
    error_message = "The 'super-repo' wasn't created'"
  }
}

run "teams_plan" {
  module {
    source = "./examples/test_app"
  }

  command = plan

  variables {
    plan = "teams"
  }

  assert {
    condition     = module.unicorns_repos.environments.super-repo.secrets.acc.variables.TFC_APPROVERS.environment == "acc"
    error_message = "The 'acc' environment variable wasn't set"
  }

  assert {
    condition     = keys(module.unicorns_repos.repositories) == ["super-repo"]
    error_message = "The 'super-repo' wasn't created'"
  }
}

run "enterprise_plan" {
  module {
    source = "./examples/test_app"
  }

  command = plan

  variables {
    plan = "enterprise"
  }

  assert {
    condition     = module.unicorns_repos.environments.super-repo.secrets.acc.variables.TFC_APPROVERS.environment == "acc"
    error_message = "The 'acc' environment variable wasn't set"
  }

  assert {
    condition     = keys(module.unicorns_repos.repositories) == ["super-repo"]
    error_message = "The 'super-repo' wasn't created'"
  }
}
