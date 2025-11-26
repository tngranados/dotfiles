# AGENTS.md

Guidance for any coding agent collaborating in this repository.

## Repository Purpose

Personal macOS dotfiles managed with modern tooling. GNU Stow drives symlink management, Homebrew Bundle installs packages via `Brewfile`, and `git-crypt` stores encrypted secrets.

## Setup Workflow

Run these steps when provisioning a new machine:

```bash
# Install Homebrew and bundle tap
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install packages and apps
brew bundle

# Link dotfiles into $HOME
stow -t "$HOME" -d "$HOME/dotfiles/config" .

# Decrypt sensitive files (requires key)
git-crypt unlock /path/to/key

# Apply macOS defaults
./setup-mac.sh
```

## Validation Commands

```bash
# Confirm stow link targets
stow -t "$HOME" -d "$HOME/dotfiles/config" -n .

# Check package state
brew bundle check

# Reload shell configuration
source ~/.zshrc
```

## Architecture Overview

- **Configuration**: `config/` mirrors `$HOME`; GNU Stow keeps symlinks reproducible.
- **Package Management**: `Brewfile` enumerates CLI tools, casks, and Mac App Store apps for `brew bundle`.
- **Shell**: ZSH config lives in `zsh/` with modular files (`aliases.zsh`, `tools.zsh`, `paths.zsh`, `fzf_*.zsh`, `mac.zsh`) plus per-machine overrides under `local/`.
- **Security**: Secrets remain encrypted in `secrets/` via `git-crypt`; never commit plaintext secrets.
- **System Defaults**: `setup-mac.sh` sets Finder, Dock, and app preferences using `defaults`.

## Key Integrations

- Runtime management with `mise` (formerly `asdf`).
- Enhanced history via Atuin.
- Git tooling includes lazygit, delta, and difftastic.
- Fuzzy finding powered by `fzf` across git, files, and history.
- Update packages through `brew bundle`.

## Agent Guidelines

- Preserve existing structure; use GNU Stow patterns when adding dotfiles.
- Keep secrets encrypted; verify `git-crypt` status before editing `secrets/`.
- When modifying shell configs, mirror changes in the corresponding file inside `zsh/`.
- When adding new shell functions or commands, update the `dothelp` function in `zsh/tools.zsh` to document them.
- Favor repeatable automation: if a manual step is required, add it to `setup-mac.sh` or document it.
- Confirm macOS defaults by inspecting bundle identifiers:
  ```bash
  mdls -name kMDItemCFBundleIdentifier -r /Applications/AppName.app
  defaults read <bundle_identifier>
  ```
