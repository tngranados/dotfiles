# Brew shellenv
eval "$(/opt/homebrew/bin/brew shellenv)"

# Antidote plugin manager
source $HOMEBREW_PREFIX/opt/antidote/share/antidote/antidote.zsh
antidote load ${ZDOTDIR:-$HOME}/.zsh_plugins.txt
