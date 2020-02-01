# Colors for ls command
if (( $+commands[gls] )); then
  eval "`gdircolors -b $DOTFILES/zsh/dircolors-solarized/dircolors.ansi-dark 2> /dev/null`"
  zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} # Use LS_COLORS for completion
  alias ls="gls --color=auto"
else
  export LSCOLORS=exfxfeaeBxxehehbadacea
  zstyle ':completion:*:default' list-colors ${(s.:.)LSCOLORS} # Use LSCOLORS for completion
  alias ls="ls -G"
fi

# Auto ls after cd
function chpwd() {
    emulate -L zsh
    ls
}

# History keybindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Text editing, this is meant to work with this iTerm2 key preset:
# https://gist.github.com/tngranados/b1aef481755a6b893ac8fd3004bf701c
bindkey '^[cmddelete' backward-kill-line
bindkey '^[altdelete' backward-kill-word
bindkey '^[altleft' backward-word
bindkey '^[cmdleft' beginning-of-line
bindkey '^[altright' forward-word
bindkey '^[cmdright' end-of-line
bindkey '^[deleteforward' delete-char
bindkey '^[cmddeleteforward' kill-line
bindkey '^[altdeleteforward' kill-word
bindkey '^[home' beginning-of-line
bindkey '^[end' end-of-line

# iTerm 2
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
