# Contributing

Testing Locally:

```shell
asdf plugin test <plugin-name> <plugin-url> [--asdf-tool-version <version>] [--asdf-plugin-gitref <git-ref>] [test-command*]

# TODO: adapt this
asdf plugin test trunk https://github.com/sdurrheimer/asdf-trunk.git "trunk --version"
```

Tests are automatically run in GitHub Actions on push and PR.
