# Load Order    Interactive  Interactive  Script
# Startup       Only login   Always
# ------------- -----------  -----------  ------
#  /etc/zshenv       1            1         1
#    ~/.zshenv       2            2         2
# /etc/zprofile       3
#   ~/.zprofile       4
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

# Fallback in case ~/.zshenv wasn't sourced (e.g. missing symlink).
: ${DOTFILES:=$HOME/dotfiles}
: ${XDG_CACHE_HOME:=$HOME/.cache}

# Brew shellenv
eval "$(/opt/homebrew/bin/brew shellenv)"

# Mise
eval "$(mise activate zsh)"

# Antidote plugin manager
source $HOMEBREW_PREFIX/opt/antidote/share/antidote/antidote.zsh
antidote load ${ZDOTDIR:-$HOME}/.zsh_plugins.txt

# Folder aliases
alias home="cd $HOME"
alias dev="cd $HOME/Developer"
alias work="cd $HOME/Developer/Work"
alias down="cd $HOME/Downloads"
alias desk="cd $HOME/Desktop"
alias dotfiles="cd $DOTFILES"

# Setup 'infinite' history
HISTFILE=$DOTFILES/local/.zsh_history
HISTSIZE=999999999
SAVEHIST=$HISTSIZE

# ZSH configuration
setopt hist_ignore_space # Don't record a history entry if it starts with a space
setopt hist_ignore_all_dups # Remove older duplicate entries from history
setopt hist_reduce_blanks # Remove superfluous blanks from history items
setopt inc_append_history_time # Save history entries as soon as they are entered, keeping different terminal separated while running
setopt extended_history # Save command duration as well as timestamp
setopt correct # Command spelling correction
setopt interactive_comments # Allow comments in interactive shell
setopt no_beep # No beep on error

if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

autoload -Uz compinit
# Full check (picks up newly installed completions) only when the dump is over a day old
() {
  if (( $# )); then
    compinit && touch $1
  else
    compinit -C
  fi
} ${ZDOTDIR:-$HOME}/.zcompdump(N.mh+24)

# Load completions system
zmodload -i zsh/complist

# Auto rehash commands
# http://www.zsh.org/mla/users/2011/msg00531.html
zstyle ':completion:*' rehash true
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
# Statusline for many hits
zstyle ':completion:*:default' select-prompt $'\e[01;35m -- Match %M    %P -- \e[00;00m'
# Show comments when present
zstyle ':completion:*' verbose yes
# Case-insensitive -> partial-word (cs) -> substring completion:
zstyle ':completion:*' matcher-list 'm:{A-Zöäüa-zÖÄÜ}={a-zÖÄÜA-Zöäü}' \
  'm:{A-Zöäüa-zÖÄÜ}={a-zÖÄÜA-Zöäü} r:|[._-]=* r:|=*' \
  'm:{A-Zöäüa-zÖÄÜ}={a-zÖÄÜA-Zöäü} l:|=* r:|=*'
# Reorder output sorting: named dirs over userdirs
zstyle ':completion::*:-tilde-:*:*' group-order named-directories users
# Advanced kill completion
zstyle ':completion::*:kill:*:*' command 'ps -U $USER -o pid,%cpu,command'
zstyle ':completion::*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;32'
# Advanced rm completion (e.g. bak files first)
zstyle ':completion::*:rm:*:*' file-patterns '*.o:object-files:object\ file *(~|.(old|bak|BAK)):backup-files:backup\ files *~*(~|.(o|old|bak|BAK)):all-files:all\ files'
# Advanced vi completion (e.g. tex and rc files first)
zstyle ':completion::*:vi:*:*' file-patterns 'Makefile|*(rc|log)|*.(php|tex|bib|sql|zsh|ini|sh|vim|rb|sh|js|tpl|csv|rdf|txt|phtml|tex|py|n3):vi-files:vim\ likes\ these\ files *~(Makefile|*(rc|log)|*.(log|rc|php|tex|bib|sql|zsh|ini|sh|vim|rb|sh|js|tpl|csv|rdf|txt|phtml|tex|py|n3)):all-files:other\ files'

# Keybindings
bindkey "^[[1;3D" .backward-word
bindkey "^[[1;3C" .forward-word
bindkey "^[[1;9D" beginning-of-line
bindkey "^[[1;9C" end-of-line
bindkey "^[[3;3~" delete-word

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

# Source all modules
for file in $DOTFILES/zsh/*.zsh(N); do
  source "$file"
done

# Source all the custom zsh files in ./zsh/local
for file in $DOTFILES/zsh/local/*.zsh(N); do
  # Check first bytes for git-crypt signature
  if [[ $(head -c 10 "$file" 2>/dev/null | tr -d '\0') == "GITCRYPT" ]]; then
    echo "Warning: $file is encrypted with git-crypt and was not loaded"
    continue
  fi
  source "$file"
done

if (( $+commands[fzf] )); then
  cached-init fzf --zsh
fi

# Atuin better history
cached-init atuin init zsh --disable-up-arrow

# Compile zsh files for faster startup
{
  # Compile .zshrc
  if [[ ! -f ~/.zshrc.zwc ]] || [[ ~/.zshrc -nt ~/.zshrc.zwc ]]; then
    zcompile ~/.zshrc
  fi
  dump=${ZDOTDIR:-$HOME}/.zcompdump
  if [[ -s $dump && ( ! -f $dump.zwc || $dump -nt $dump.zwc ) ]]; then
    zcompile $dump
  fi
  # Compile all custom zsh modules
  for file in $DOTFILES/zsh/*.zsh(N) $DOTFILES/zsh/local/*.zsh(N); do
    if [[ -f "$file" ]] && [[ ! -f "$file.zwc" || "$file" -nt "$file.zwc" ]]; then
      zcompile "$file" 2>/dev/null
    fi
  done
} &!
