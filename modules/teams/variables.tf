variable "repository" {
  description = "Name of the repository we're adding var.teams_info{}s to"
  type        = string
}

variable "teams_info" {
  description = "ID of team and corresponding permissions to give them"

  type = map(object({
    id         = number
    permission = optional(string, "push")
  }))
}

variable "collaborators" {
  description = "For outside collaborators"

  type = map(object({
    username                    = string,
    permission                  = optional(string, "pull")
    permission_diff_suppression = optional(bool, false)
  }))

  default = {}
}
