terraform {
  required_version = ">= 1.6.1, < 1.7.0"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.0.0"
    }
  }
}
