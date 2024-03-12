Simple helper module that allows you to configure a Github module all in a single place, including:

- Environments and their secrets, variables, and reviewers
- Teams assigned to the repository, and their permission
- Advanced security settings. Either needs an enterprise plan (for which `var.plan` should be set to `enterprise`), or a public repository (where `var.repositorie{}.visibility` is set to `public`)
