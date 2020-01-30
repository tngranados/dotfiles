# History keybindings
bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down

# Activate dircolors
eval "`dircolors -b $DOTFILES/zsh/dircolors-solarized/dircolors.256dark 2> /dev/null`"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} # Use LS_COLORS for completion

# Auto ls after cd
function chpwd() {
    emulate -L zsh
    ls
}

# Enable ls colors
alias ls="ls --color"

# Use xdg-open as open
alias open="xdg-open"

# Linux brew
export PATH=$PATH:/home/linuxbrew/.linuxbrew/bin

