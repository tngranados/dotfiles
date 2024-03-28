# GitHub
eval "$(gh completion -s zsh)"

# Zoxide
eval "$(zoxide init zsh)"

# Unix tools replacements
if (( $+commands[duf] )); then
  alias df='duf'
fi
if (( $+commands[bat] )); then
  alias cat="bat -p --theme=\$(defaults read -globalDomain AppleInterfaceStyle &> /dev/null && echo Coldark-Dark || echo GitHub)"
fi
if (( $+commands[dust] )); then
  alias du="dust"
fi
