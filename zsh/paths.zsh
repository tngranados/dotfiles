# Ensure no duplicates in PATH
typeset -U path

# Define all paths at once
path=(
  "$HOME/.cargo/bin"
  "$HOME/.yarn/bin"
  "$HOME/.config/yarn/global/node_modules/.bin"
  "$HOME/.antigravity/antigravity/bin"
  $path
  "$DOTFILES/bin"
  "$DOTFILES/bin/local"
  "$DOTFILES/bin/basic"
)
