# History keybindings
bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down

# Activate dircolors
eval "`dircolors -b $DOTFILES/zsh/dircolors-solarized/dircolors.256dark 2> /dev/null`"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} # Use LS_COLORS for completion

# Enable ls colors and use human readable file sizes
alias ls="ls --color -h"

# Auto ls after cd
function chpwd() {
    emulate -L zsh
    ls
}

# Use xdg-open as open
alias open="xdg-open"

# Linux brew
export PATH=$PATH:/home/linuxbrew/.linuxbrew/bin

# Reproduce a beep when a task finishes
negativebeep() {
    ( speaker-test -t sine -f 800 >/dev/null )& pid=$!;
    sleep 0.5s >/dev/null;
    kill -9 $pid >/dev/null
}

positivebeep() {
    ( speaker-test -t sine -f 1000 >/dev/null )& pid=$! 
    sleep 0.15s >/dev/null;
    kill -9 $pid >/dev/null
    sleep 0.15s >/dev/null;
    ( speaker-test -t sine -f 1000 >/dev/null )& pid=$!;
    sleep 0.15s >/dev/null;
    kill -9 $pid >/dev/null
}

beep() {
    setopt LOCAL_OPTIONS NO_NOTIFY NO_MONITOR
    previous=$?
    if [ $previous -eq 0 ]; then
        positivebeep
    else
        negativebeep
    fi
}
