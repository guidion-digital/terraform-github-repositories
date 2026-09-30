Simple helper module that allows you to configure a Github module all in a single place, including:

- Environments and their secrets, variables, and reviewers
- Teams assigned to the repository, and their permission
- Advanced security settings. Either needs an enterprise plan (for which `var.plan` should be set to `enterprise`), or a public repository (where `var.repositorie{}.visibility` is set to `public`)
- Creating a repository from an existing GitHub template

To create a repository from a template, set `template` on its entry in `repositories`:

```hcl
repositories = {
  "new-service" = {
    visibility = "private"
    template = {
      owner      = "my-organization"
      repository = "service-template"
    }
  }
}
```

`include_all_branches` is optional and defaults to `false`, so GitHub copies only the template's default branch. The template repository must exist and contain the desired files before the new repository is created. Leave `auto_init` unset when using `template`; the module rejects `auto_init = true` with a template.
