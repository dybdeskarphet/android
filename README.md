# Android

Termux dotfiles managed with chezmoi.

## Requirements

- Termux
- Termux:API

## Installation

```sh
pkg update && pkg install git chezmoi
chezmoi init --apply dybdeskarphet/android
```

## Declarative Package Management

Dependencies and tools are managed declaratively in `.chezmoidata/`:

- `packages.yaml` - Native Termux packages (`pkg`), global pip tools, and npm packages
- `proot.yaml` - Debian PRoot container configuration, APT packages, and Python stack
- `yazi.yaml` - Yazi file manager plugins

Do not install software imperatively (avoid `pkg install` or `pip install`). Define all packages and tools in the corresponding YAML file and run `chezmoi apply` to keep the environment reproducible and tracked.

## Setup Scripts

- `run_onchange_before_install-packages` - Installs packages, language tools, and LSPs from `packages.yaml`
- `run_onchange_after_setup-storage` - Requests Android storage access and creates short symlinks (`~/sd`, `~/doc`, `~/dl`)
- `run_onchange_after_setup-proot` - Provisions the Debian container and Python environment via `proot-distro`
- `run_onchange_after_install-mise` - Installs and updates tools managed by Mise
- `run_onchange_after_install-yazi-plugins` - Installs Yazi plugins via `ya pkg`
- `run_once_after_set-default-shell` - Sets Fish as the default Termux shell
- `run_onchange_after_add_ssh_authorized_key` - Adds authorized SSH public key, used for connecting to Termux from PC. **(change with your own)**

## Common Commands

Update repository and apply changes:

```sh
chezmoi update
```

Apply local changes:

```sh
chezmoi apply
```

Review differences:

```sh
chezmoi diff
```
