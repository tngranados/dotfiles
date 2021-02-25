# Load Order    Interactive  Interactive  Script
# Startup       Only login   Always
# ------------- -----------  -----------  ------
#  /etc/zshenv       1            1         1
#    ~/.zshenv       2            2         2
# /etc/zprofile      3
#   ~/.zprofile      4
# /etc/zshrc         5            3
#   ~/.zshrc         6            4
# /etc/zlogin        7
#   ~/.zlogin        8
#
# Shutdown
# ------------- -----------  -----------  ------
#   ~/.zlogout       9
# /etc/zlogout      10
#
# Note: ZSH seems to read ~/.profile as well, if ~/.zshrc is not present.

# Check dotfiles location
if [ "${DOTFILES+set}" != set ]; then
  DOTFILES="$HOME/dotfiles"
fi

# Folder aliases
alias home="cd $HOME"
alias dev="cd $HOME/Developer"
alias tn="cd $HOME/Developer/tngranados"
alias down="cd $HOME/Downloads"
alias desk="cd $HOME/Desktop"

export EDITOR="vim"

# Useful command aliases
alias vimrc="$EDITOR $HOME/.vimrc"
alias rsource="source $HOME/.zshrc"
alias g="git"
alias gs="g s"
alias vi="vim"
alias grep="grep  --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}"
alias -g G="| grep -i"
alias -s git="git clone"
alias j="z"

# Creates a static server using ruby, php, or python 2 or 3, whichever is
# available. It support an optional port (default is 8000).
shttp() {
  local port="${1:-8000}"
  if (( $+commands[ruby] )); then
    ruby -run -ehttpd . -p$port
  elif (( $+commands[php] )); then
    php -S localhost:$port
  elif (( $+commands[python] )); then
    local pythonVer=$(python -c 'import platform; major, _, _ = platform.python_version_tuple(); print(major);')
    if [ $pythonVer -eq 2 ]; then
      python -m SimpleHTTPServer $port
    else
      python -m http.server $port
    fi
  else
    echo "Error: Ruby, PHP or Python needed"
  fi
}

# Docker
dockerrmf() {
  docker rm -vf $(docker ps -a -q)
}
dockerrmif() {
  docker rmi -f $(docker images -a -q)
}
alias dcup="docker-compose up -d"
alias dcdown="docker-compose down"

# Grep something over a git repository currently modified or added files. First paremter is the search term, the rest of
# them are regexp of ignored files.
gitg() {
  local term=$1

  shift
  local ignored_files=${(j:|:)${@}}

  git status --porcelain | awk 'match($1, "A|M"){print $2}' | rg -v "${ignored_files}" | xargs rg $term
}

# Setup 'infinite' history
HISTFILE=~/.zsh_history
HISTSIZE=999999999
SAVEHIST=$HISTSIZE

# ZSH configuration
alias ssh-hosts="grep -P \"^Host ([^*]+)$\" $HOME/.ssh/config | sed 's/Host //'"
alias dotfiles="cd $DOTFILES"
alias zprofile="$EDITOR $DOTFILES/local/zsh/zprofile.zsh"
setopt hist_ignore_all_dups # Remove older duplicate entries from history
setopt hist_reduce_blanks # Remove superfluous blanks from history items
setopt inc_append_history # Save history entries as soon as they are entered
setopt share_history # Share history between different instances of the shell
alias cls="clear; printf '\033[3J'" # Clear screen and scroll buffer
alias cp="cp -i"; # Confirm before overwrite
alias mv="mv -i"; # Confirm before overwrite
alias df="df -h"; # Human-readable sizes
alias historystats="history 1 | awk '{print $2}' | sort | uniq -c | sort -n"
alias gitprune="git branch --merged | grep -Ev '(master)' >/tmp/merged-branches && vi /tmp/merged-branches && xargs git branch -d </tmp/merged-branches"

autoload -Uz compinit
compinit

# Load completions system
zmodload -i zsh/complist

# Ctrl + space to go to subdirectories
bindkey -M menuselect '^@' accept-and-infer-next-history

# Auto rehash commands
# http://www.zsh.org/mla/users/2011/msg00531.html
zstyle ':completion:*' rehash true
# Menu selection
zstyle ':completion:*' menu select=1
# Select completions with arrow keys
zstyle ':completion:*' menu select 
# Completion of .. directories
zstyle ':completion:*' special-dirs true
# Group results by category
zstyle ':completion:*' group-name ''
# Grouping / headline / ...
zstyle ':completion:*:messages' format $'\e[01;35m -- %d -- \e[00;00m'
zstyle ':completion:*:warnings' format $'\e[01;31m -- No Matches Found -- \e[00;00m'
zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d -- \e[00;00m'
zstyle ':completion:*:corrections' format $'\e[01;33m -- %d -- \e[00;00m'
# Colors
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# Fault tolerance
zstyle ':completion:*' completer _complete _correct _approximate
# (1 error on 3 characters)
zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'
# Case insensitivity
zstyle ":completion:*" matcher-list 'm:{A-Zöäüa-zÖÄÜ}={a-zÖÄÜA-Zöäü}'
# Statusline for many hits
zstyle ':completion:*:default' select-prompt $'\e[01;35m -- Match %M    %P -- \e[00;00m'
# Show comments when present
zstyle ':completion:*' verbose yes
# Case-insensitive -> partial-word (cs) -> substring completion:
zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'  
# Reorder output sorting: named dirs over userdirs
zstyle ':completion::*:-tilde-:*:*' group-order named-directories users
# Advanced kill completion
zstyle ':completion::*:kill:*:*' command 'ps xf -U $USER -o pid,%cpu,cmd'
zstyle ':completion::*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;32'
# Advanced rm completion (e.g. bak files first)
zstyle ':completion::*:rm:*:*' file-patterns '*.o:object-files:object\ file *(~|.(old|bak|BAK)):backup-files:backup\ files *~*(~|.(o|old|bak|BAK)):all-files:all\ files'
# Advanced vi completion (e.g. tex and rc files first)
zstyle ':completion::*:vi:*:*' file-patterns 'Makefile|*(rc|log)|*.(php|tex|bib|sql|zsh|ini|sh|vim|rb|sh|js|tpl|csv|rdf|txt|phtml|tex|py|n3):vi-files:vim\ likes\ these\ files *~(Makefile|*(rc|log)|*.(log|rc|php|tex|bib|sql|zsh|ini|sh|vim|rb|sh|js|tpl|csv|rdf|txt|phtml|tex|py|n3)):all-files:other\ files'

# Keybindings
bindkey "^[[1;5D" .backward-word
bindkey "^[[1;5C" .forward-word
bindkey "^[[1;6D" backward-delete-word
bindkey "^[[1;6C" delete-word
# fn-left
bindkey "^[[H" .backward-word
# fn-right
bindkey "^[[F" .forward-word

# Make cd push the old directory onto the directory stack.
setopt AUTO_PUSHD

# Don’t push multiple copies of the same directory onto the directory stack.
setopt PUSHD_IGNORE_DUPS

# Configure prompt
GEOMETRY_PATH_SHOW_BASENAME=true

# Help stuff
cheat() {
  curl "http://cheat.sh/$1"
}

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# Add yarn to PATH
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# LGTM
lgtm() {
  yarn lint --fix || { echo -e '\n\n \e[31mSomething went wrong: javascript linting\e[m \n\n' && error-sound && return false }
  rubocop -a || { echo -e '\n\n \e[31mSomething went wrong: ruby linting\e[m \n\n' && error-sound && return false }
  yarn test || { echo -e '\n\n \e[31mSomething went wrong: javascript testing\e[m \n\n' && error-sound && return false }
  rspec || { echo -e '\n\n \e[31mSomething went wrong: ruby testing\e[m \n\n' && error-sound && return false }

  success-sound

  if [[ -n $(git status -s) ]]; then
    git status
    echo -e '\n\n \e[33mAll good, but git status is dirty\e[m \n\n'
  else
    echo -e '\n\n \e[32mAll good, LGTM!\e[m  \n\n'
  fi

  return true
}

# Append automatically % to numbers in fg and bg
fg() {
    if [[ $# -eq 1 && $1 = - ]]; then
        builtin fg %-
    else
        builtin fg %"$@"
    fi
}

bg() {
    if [[ $# -eq 1 && $1 = - ]]; then
        builtin bg %-
    else
        builtin bg %"$@"
    fi
}

# Source all the custom zsh files in ./local/zsh
for file in $DOTFILES/local/zsh/*.zsh; do
  source "$file"
done
