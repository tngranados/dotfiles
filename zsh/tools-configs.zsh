# Source a tool's generated shell init, regenerating it when the binary is upgraded or the args change
cached-init() {
  : ${XDG_CACHE_HOME:=$HOME/.cache}
  local cache=${XDG_CACHE_HOME}/zsh/init-${${(j:_:)@}//[^[:alnum:]_-]/}.zsh
  if [[ ! -s $cache || $commands[$1] -nt $cache ]]; then
    mkdir -p "${cache:h}" && command "$@" >| "$cache"
  fi
  [[ -s $cache ]] && source "$cache"
}

# GitHub
cached-init gh completion -s zsh

# Zoxide
cached-init zoxide init zsh

# Unix tools replacements
if (( $+commands[duf] )); then
  alias df='duf'
fi
if (( $+commands[bat] )) && [[ "$AI_AGENT" != "true" ]]; then
  alias cat="bat -p --theme=auto:system --theme-dark=OneHalfDark --theme-light=GitHub"
fi
if (( $+commands[dust] )); then
  alias du="dust"
fi

# Try  https://github.com/tobi/try
cached-init try init ~/Developer/tries
