# Devenv Django Example

## Overview

This repository is a demonstrative example on how to use [Devenv](https://devenv.sh) to spin up complete development environments in seconds. The base project used is a Python [Django](https://docs.djangoproject.com) website.

## Getting Started

### Install Nix and Devenv

If you already have `nix` and `devenv` installed, you can skip the following section.

1. Install Nix using the following command:

```sh
curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate
```

2. Add your user to the trusted users in `/etc/nix/nix.custom.conf`:

```sh
echo "trusted-users = root $USER" | sudo tee /etc/nix/nix.custom.conf
```

3. Install `devenv`:

```sh
nix profile add nixpkgs#devenv
```

4. Verify `devenv` is accessible:

```sh
devenv --version
```

### Activate Development Environment

1. Navigate to the path where you cloned the repository:

```sh
cd path/to/repo
```

2. Activate `devenv` environment:

```sh
devenv shell
```

### Setup Automatic Shell Activation

1. Install `direnv`:

```sh
nix profile add nixpkgs#direnv nixpkgs#nix-direnv
```

2. Hook `direnv` into your shell (refer to [`direnv` docs](https://direnv.net/docs/hook.html) for other shells):

```sh
# NOTE: Use equivalent for your shell
echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
# NOTE: You can also open a new shell session
source ~/.bashrc
```

3. Create `.envrc` file in repository directory:

```sh
cat <<"EOF" > .envrc
#!/usr/bin/env bash

eval "$(devenv direnvrc)"

# You can pass flags to the devenv command
# For example: use devenv --impure --option services.postgres.enable:bool true
use devenv
EOF
```

4. Allow `direnv` to automatically load `.envrc` from this directory:

```sh
direnv allow .
```

## Acknowledgements

- Original Django repository: <https://github.com/rtzll/django-todolist>
