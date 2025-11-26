# AGENTS.md

Guidance for any coding agent collaborating in this repository.

## Repository Purpose

Personal macOS dotfiles managed with modern tooling. GNU Stow drives symlink management, Homebrew Bundle installs packages via `Brewfile`, and `git-crypt` stores encrypted secrets.

## Directory Structure

```
dotfiles/
├── AGENTS.md           # This file - agent guidance
├── Brewfile            # Homebrew packages, casks, and MAS apps
├── install.sh          # Cross-platform stow installer
├── setup-mac.sh        # macOS defaults configuration
├── config/             # Files symlinked to $HOME via stow
│   ├── .zshrc          # Main shell config
│   └── .zsh_plugins.txt
├── zsh/                # Modular shell configs (sourced by .zshrc)
│   ├── aliases.zsh     # Command aliases
│   ├── tools.zsh       # Custom functions + dothelp
│   ├── paths.zsh       # PATH modifications
│   ├── mac.zsh         # macOS-specific settings
│   ├── fzf_*.zsh       # FZF integrations
│   └── local/          # Machine-specific overrides (some encrypted)
├── bin/                # Custom scripts added to PATH
│   ├── basic/          # Simple utility scripts
│   └── local/          # Machine-specific scripts
├── secrets/            # Encrypted files via git-crypt
└── local/              # Local data (history, etc.) - not symlinked
```

## Setup Workflow

Run these steps when provisioning a new machine:

```bash
# Install Homebrew and bundle tap
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install packages and apps
brew bundle

# Link dotfiles into $HOME
./install.sh
# Or manually: stow -t "$HOME" -d "$HOME/dotfiles/config" .

# Decrypt sensitive files (requires key)
git-crypt unlock /path/to/key

# Apply macOS defaults
./setup-mac.sh
```

## Validation Commands

```bash
# Confirm stow link targets (dry-run)
stow -t "$HOME" -d "$HOME/dotfiles/config" -n .

# Check package state
brew bundle check

# Reload shell configuration
source ~/.zshrc

# Verify git-crypt status
git-crypt status
```

## Architecture Overview

| Component           | Location       | Purpose                                    |
| ------------------- | -------------- | ------------------------------------------ |
| **Config files**    | `config/`      | Mirrors `$HOME`; GNU Stow creates symlinks |
| **Packages**        | `Brewfile`     | CLI tools, casks, and Mac App Store apps   |
| **Shell modules**   | `zsh/*.zsh`    | Modular configs sourced by `.zshrc`        |
| **Custom scripts**  | `bin/`         | Executables added to `$PATH`               |
| **Secrets**         | `secrets/`     | Encrypted via `git-crypt`                  |
| **System defaults** | `setup-mac.sh` | Finder, Dock, app preferences              |

## Key Integrations

- **Runtime management**: `mise` (Ruby, Node, Python, etc.)
- **Shell history**: Atuin (synced, searchable history)
- **Git tooling**: lazygit, delta, difftastic
- **Fuzzy finding**: `fzf` across git, files, and history
- **Package updates**: `brew bundle`

## Agent Guidelines

### General Rules

- Preserve existing structure; use GNU Stow patterns when adding dotfiles.
- Keep secrets encrypted; verify `git-crypt status` before editing `secrets/`.
- Favor repeatable automation: if a manual step is required, add it to `setup-mac.sh` or document it.

### Shell Configuration

- When modifying shell configs, place changes in the appropriate file inside `zsh/`:
  - Aliases → `aliases.zsh`
  - Functions → `tools.zsh`
  - PATH changes → `paths.zsh`
  - macOS-specific → `mac.zsh`
  - FZF integrations → `fzf_*.zsh`
- When adding new shell functions or commands, update the `dothelp` function in `zsh/tools.zsh`.

### Adding Packages

- Add new CLI tools and apps to `Brewfile` with a descriptive comment.
- Group entries logically with existing sections.

### Adding Scripts

- Place new scripts in `bin/` (or `bin/basic/` for simple utilities).
- Make scripts executable: `chmod +x bin/script-name`.
- Add documentation to `dothelp` if the script is commonly used.

### macOS Defaults

- Confirm bundle identifiers before adding defaults:
  ```bash
  mdls -name kMDItemCFBundleIdentifier -r /Applications/AppName.app
  defaults read <bundle_identifier>
  ```
- Add new defaults to `setup-mac.sh` grouped with related apps.
