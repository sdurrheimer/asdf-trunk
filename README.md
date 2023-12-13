<div align="center">

# asdf-trunk [![Build](https://github.com/sdurrheimer/asdf-trunk/actions/workflows/build.yml/badge.svg)](https://github.com/sdurrheimer/asdf-trunk/actions/workflows/build.yml) [![Lint](https://github.com/sdurrheimer/asdf-trunk/actions/workflows/lint.yml/badge.svg)](https://github.com/sdurrheimer/asdf-trunk/actions/workflows/lint.yml)

[trunk](https://docs.trunk.io/) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add trunk
# or
asdf plugin add trunk https://github.com/sdurrheimer/asdf-trunk.git
```

trunk:

```shell
# Show all installable versions
asdf list-all trunk

# Install specific version
asdf install trunk latest

# Set a version globally (on your ~/.tool-versions file)
asdf global trunk latest

# Now trunk commands are available
trunk --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/sdurrheimer/asdf-trunk/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Steve Durrheimer](https://github.com/sdurrheimer/)
