#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OVERWRITE=0

log() {
  printf '[dotfiles] %s\n' "$*"
}

warn() {
  printf '[dotfiles] %s\n' "$*" >&2
}

usage() {
  cat <<EOF
Usage: install.sh [-f|--overwrite] [-h|--help]

  -f, --overwrite   Move conflicting targets to ~/.dotfiles-backup/<timestamp> before stowing.
  -h, --help        Show this help and exit.
EOF
}

parse_args() {
  while [ "$#" -gt 0 ]; do
    case "$1" in
      -f|--overwrite) OVERWRITE=1 ;;
      -h|--help) usage; exit 0 ;;
      *) warn "Unknown option: $1"; usage; exit 1 ;;
    esac
    shift
  done
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

rel_link() {
  local src="$1" dst="$2" rel="$1"
  mkdir -p "$(dirname "$dst")"
  if command -v python3 >/dev/null 2>&1; then
    rel="$(python3 -c 'import os,sys; print(os.path.relpath(sys.argv[1], sys.argv[2]))' "$src" "$(dirname "$dst")")"
  fi
  ln -sfn "$rel" "$dst"
}

stow_conflicts() {
  stow --restow --no --dir="$ROOT_DIR/config" --target="$HOME" . 2>&1 >/dev/null \
    | tr -d "\`'\"" \
    | sed -n -e 's/.*over existing target \([^ ]*\).*/\1/p' -e 's/.*not owned by [Ss]tow: *\([^ ]*\).*/\1/p'
}

backup_conflicts() {
  local conflicts backup_dir target ts
  conflicts="$(stow_conflicts || true)"
  if [ -z "$conflicts" ]; then
    return 0
  fi
  ts="$(date +%Y%m%d-%H%M%S)"
  backup_dir="$HOME/.dotfiles-backup/$ts"
  while IFS= read -r target; do
    [ -n "$target" ] || continue
    [ -e "$HOME/$target" ] || [ -L "$HOME/$target" ] || continue
    mkdir -p "$(dirname "$backup_dir/$target")"
    mv "$HOME/$target" "$backup_dir/$target"
    log "Backed up ~/$target to ~/.dotfiles-backup/$ts/$target"
  done <<< "$conflicts"
}

link_dotfiles() {
  log "Linking dotfiles into \$HOME via stow..."
  if [ "$OVERWRITE" -eq 1 ]; then
    backup_conflicts
  fi
  if ! stow --restow --dir="$ROOT_DIR/config" --target="$HOME" .; then
    warn "Stow hit a conflict. Remove or back up the file above and rerun, or rerun with --overwrite to move conflicts to ~/.dotfiles-backup/."
    return 1
  fi
}

# Overlays need a real directory: when stow folds $1 into a symlink (fresh
# target), replace it with a directory and repopulate, so ln never writes
# through the fold into the repo.
ensure_real_dir() {
  if [ -L "$1" ]; then
    log "Unfolding $1 into a real directory..."
    rm "$1"
    mkdir -p "$1"
    link_dotfiles
  fi
}

# Per-file links into stateful app dirs, as "repo-rel-src:home-rel-dst".
# Overlays live outside the stow tree: stow would fold whole directories
# (e.g. ~/.pi/agent), letting app state leak into the repo.
OVERLAYS=(
  "config/.agents/AGENTS.md:.claude/CLAUDE.md"
  "config/.agents/AGENTS.md:.codex/AGENTS.md"
  "overlays/pi/settings.json:.pi/agent/settings.json"
  "overlays/pi/models.json:.pi/agent/models.json"
)

link_overlays() {
  local entry src dst
  log "Linking overlays..."
  for entry in "${OVERLAYS[@]}"; do
    src="$ROOT_DIR/${entry%%:*}"
    dst="$HOME/${entry#*:}"
    ensure_real_dir "$(dirname "$dst")"
    rel_link "$src" "$dst"
  done
}

main() {
  parse_args "$@"

  if ensure_stow; then
    link_dotfiles
  else
    log "Install stow manually and rerun this script to link the config/ tree."
  fi

  link_overlays

  log "Done. Remaining setup: brew bundle, git-crypt unlock /path/to/key, ./setup-mac.sh, source ~/.zshrc."
}

main "$@"
