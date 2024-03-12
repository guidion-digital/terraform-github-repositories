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
