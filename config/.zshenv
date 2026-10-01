# Sourced by every zsh, including scripts: keep it to cheap exports

export DOTFILES="${DOTFILES:-$HOME/dotfiles}"

# Homebrew isn't on PATH yet here, so EDITOR can't be detected with `hash`
export EDITOR=nvim

# XDG Base Directory Specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"
