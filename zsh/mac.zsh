export LSCOLORS="EHfxcxdxBxegecabagacad" 

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
bindkey '^[cmddeleteforward' kill-line
bindkey '^[altdeleteforward' kill-word
bindkey '^[home' beginning-of-line
bindkey '^[end' end-of-line
