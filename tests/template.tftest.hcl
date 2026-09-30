mock_provider "github" {}

run "template_plan" {
  command = plan

  variables {
    repositories = {
      generated = {
        template = {
          owner                = "example-org"
          repository           = "service-template"
          include_all_branches = true
        }
      }
    }
  }

  assert {
    condition     = github_repository.these["generated"].template[0].owner == "example-org" && github_repository.these["generated"].template[0].repository == "service-template" && github_repository.these["generated"].template[0].include_all_branches
    error_message = "The source repository and branch option must reach the GitHub repository resource."
  }
}

run "reject_auto_init_with_template" {
  command = plan

  variables {
    repositories = {
      generated = {
        auto_init = true
        template = {
          owner      = "example-org"
          repository = "service-template"
        }
      }
    }
  }

  expect_failures = [var.repositories]
}
