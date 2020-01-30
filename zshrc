# Check dotfiles location
if [ "${DOTFILES+set}" != set ]; then
  DOTFILES="$HOME/dotfiles"
fi

# Activate dircolors
eval "`dircolors -b $DOTFILES/zsh/dircolors-solarized/dircolors.256dark 2> /dev/null`"

# Useful command aliases
export EDITOR="vim"
alias g="git"
alias vi="vim"
alias grep="grep  --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}"
alias -g G="| grep -i"
alias shttp="python -m SimpleHTTPServer 8000"

# Auto ls after cd
function chpwd() {
    emulate -L zsh
    ls
}

# Setup 'infinite' history
HISTFILE=~/.zsh_history
HISTSIZE=999999999
SAVEHIST=$HISTSIZE

# ZSH configuration
alias dotfiles="cd $DOTFILES"
alias zprofile=" $EDITOR $DOTFILES/local/zsh/zprofile.zsh"
setopt hist_ignore_all_dups # Remove older duplicate entries from history
setopt hist_reduce_blanks # Remove superfluous blanks from history items
setopt inc_append_history # Save history entries as soon as they are entered
setopt share_history # Share history between different instances of the shell
setopt correct_all # Autocorrect commands
alias go="nocorrect go" # Avoid autocorrect when running go get ./... or go test ./...
alias ruby="nocorrect ruby" # Avoid autocorrect ruby
alias rails="nocorrect rails" # Avoid autocorrect rails

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

# Source all the custom zsh files in ./local/zsh
for file in $DOTFILES/local/zsh/*.zsh; do
  source "$file"
done

# Configure prompt
GEOMETRY_PATH_SHOW_BASENAME=true

# Use fzf-tab plugin for auto copmletion.
if (( $+commands[fzf] )); then
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
  source "$DOTFILES/zsh/fzf-tab/fzf-tab.plugin.zsh"
fi

# Help stuff
cheat() {
  curl "http://cheat.sh/$1"
}

