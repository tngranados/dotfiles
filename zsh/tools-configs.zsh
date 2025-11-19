# GitHub
eval "$(gh completion -s zsh)"

# Zoxide
eval "$(zoxide init zsh)"

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
eval "$(/opt/homebrew/bin/try init ~/Developer/tries)"
