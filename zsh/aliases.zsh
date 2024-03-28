# Useful command aliases
alias fullhistory="history -fD 0"
alias vimrc="$EDITOR $HOME/.config/nvim/init.vim"
alias zprofile="$EDITOR $DOTFILES/local/zsh/zprofile.zsh"
alias rsource="source $HOME/.zshrc"
alias g="git"
alias gs="g s"
alias gss="g ss"
alias gap="g ap"
alias grp="g rp"
alias grmp="g rmp"
alias vi="nvim"
alias vim="nvim"
alias grep="grep  --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}"
alias -g G="| grep -i"
alias -s git="git clone"
alias cls="clear; printf '\033[3J'" # Clear screen and scroll buffer
alias cp="cp -i"; # Confirm before overwrite
alias mv="mv -i"; # Confirm before overwrite
alias df="df -h"; # Human-readable sizes
alias gitprune="git branch --merged | grep -Ev '(^\*|master|main)' >/tmp/merged-branches && vi /tmp/merged-branches && xargs git branch -d </tmp/merged-branches"
alias gitprunef="git branch --merged | grep -Ev '(^\*|master|main)' | xargs git branch -d"
alias -g C="| cat --paging=never"
alias lastcommitfiles="git show --pretty="" --name-only HEAD"
alias jsc="/System/Library/Frameworks/JavaScriptCore.framework/Versions/Current/Helpers/jsc"
alias lgit="lazygit"
alias brownnoise="play -n synth brownnoise synth pinknoise mix"
alias brownnoisewaves="play -n synth brownnoise synth pinknoise mix synth sine amod 0.1 80"
alias whitenoise="play -q -c 2 -n synth brownnoise band -n 1600 1500 tremolo .1 30"
alias pinknoise="play -t sl -r48000 -c2 -n synth -1 pinknoise .1 80"
alias dcup="docker-compose up -d"
alias dcdown="docker-compose down"