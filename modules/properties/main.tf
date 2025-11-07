terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.7.5"
    }
  }
}

variable "repository" {
  description = "Repository we're acting on"
  type        = string
}

variable "properties" {
  description = "Properties map to apply to the repository"
  type = map(object({
    type  = string
    value = list(string)
  }))
}

resource "github_repository_custom_property" "string" {
  for_each = var.properties

  repository     = var.repository
  property_name  = each.key
  property_type  = each.value.type
  property_value = each.value.value
}
