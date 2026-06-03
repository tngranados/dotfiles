#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log() {
  printf '[dotfiles] %s\n' "$*"
}

ensure_stow() {
  if command -v stow >/dev/null 2>&1; then
    return 0
  fi

  if command -v apt-get >/dev/null 2>&1; then
    log "Installing GNU Stow via apt..."
    sudo apt-get update
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y stow
    return 0
  fi

  if command -v brew >/dev/null 2>&1; then
    log "Installing GNU Stow via Homebrew..."
    brew install stow
    return 0
  fi

  log "GNU Stow not available; skipping automatic symlink setup."
  return 1
}

link_dotfiles() {
  log "Linking dotfiles into \$HOME via stow..."
  stow --restow --dir="$ROOT_DIR/config" --target="$HOME" .
}

# Tool-agnostic agent guidance lives in agents/ and is symlinked to the path
# each tool expects. Kept outside config/ so stow doesn't mirror it into $HOME.
link_agents() {
  log "Linking agent files..."
  mkdir -p "$HOME/.claude"
  ln -sfn "$ROOT_DIR/agents/AGENTS.md" "$HOME/.claude/CLAUDE.md"
}

main() {
  link_agents

  if ! ensure_stow; then
    log "Install stow manually and rerun this script to complete setup."
    return 0
  fi

  link_dotfiles
}

main "$@"
