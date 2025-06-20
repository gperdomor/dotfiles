# dotfiles

This repo contains the configuration to setup my machines. This is using [Chezmoi](https://chezmoi.io), the dotfile manager to setup the install.

This automated setup is currently only configured for macOS machines.

## Prepare

1. Install command line tools

```shell
xcode-select --install
```

2. Install Homebrew, Chezmoi and launch configuration

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## How to run

```shell
export GITHUB_USERNAME=gperdomor
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply $GITHUB_USERNAME
```

## License

dotfiles is released under the [MIT License](LICENSE).
