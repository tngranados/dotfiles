export COLORS_PATH=$DOTFILES/zsh/dircolors-solarized/dircolors.ansi-universal

# Enable ls colors and use human readable file sizes
if (( $+commands[eza] )); then
  eval "`gdircolors -b $COLORS_PATH 2> /dev/null`"
  zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} # Use LS_COLORS for completion
  alias ls='eza --color=auto'
elif (( $+commands[gls] )); then
  eval "`gdircolors -b $COLORS_PATH 2> /dev/null`"
  zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} # Use LS_COLORS for completion
  alias ls="gls --color=auto -h"
else
  export LSCOLORS=exfxfeaeBxxehehbadacea
  zstyle ':completion:*:default' list-colors ${(s.:.)LSCOLORS} # Use LSCOLORS for completion
  alias ls="ls -G -h"
fi

# Auto ls after cd
function chpwd() {
    emulate -L zsh
    ls
}

# History keybindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Workaround to avoid multiple VSCode icons in the dock when using the code tool.
# https://github.com/microsoft/vscode/issues/60579
code() {
    if [ -t 1 ] && [ -t 0 ]; then
        open -a Visual\ Studio\ Code.app "$@"
    else
        open -a Visual\ Studio\ Code.app -f
    fi
}

# Aliases
alias logs="cd /usr/local/var/log"

# Sound functions
boop() {
  local last="$?"
  if [[ "$last" == '0' ]]; then
    success-sound
  else
    error-sound
  fi
  $(exit "$last")
}

error-sound() {
  ( afplay /System/Library/Sounds/Sosumi.aiff & )
}

success-sound() {
  ( afplay /System/Library/Sounds/Glass.aiff & )
}

reset-icloud-tabs() {
  rm $HOME/Library/Containers/com.apple.Safari/Data/Library/Safari/CloudTabs.db*
}
