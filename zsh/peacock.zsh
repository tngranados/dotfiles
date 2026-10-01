# Tint the terminal with the repo's VS Code Peacock color (.vscode/settings.json)

autoload -Uz add-zsh-hook
typeset -g _peacock_root=unset

_peacock_apply() {
  local root=$(git rev-parse --show-toplevel 2>/dev/null)
  [[ $root == $_peacock_root ]] && return
  _peacock_root=$root

  local color settings=$root/.vscode/settings.json
  if [[ -n $root && -r $settings && $(<$settings) =~ '"peacock\.color"[[:space:]]*:[[:space:]]*"(#[0-9a-fA-F]{6})"' ]]; then
    color=$match[1]
  fi

  if [[ -z $color ]]; then
    unset GEOMETRY_PATH_COLOR GEOMETRY_STATUS_COLOR
    [[ $TERM_PROGRAM == ghostty ]] && printf '\e]111\a'
    return
  fi

  GEOMETRY_PATH_COLOR=$color
  GEOMETRY_STATUS_COLOR=$color

  # Bases must match the backgrounds of the Ghostty themes in config/.config/ghostty/config
  [[ $TERM_PROGRAM == ghostty ]] || return
  local base=f4f4f4 weight=10
  if [[ $(defaults read -g AppleInterfaceStyle 2>/dev/null) == Dark ]]; then
    base=101216 weight=18
  fi
  local i out=
  for i in 2 4 6; do
    local -i b=$((16#${base[i-1,i]})) c=$((16#${color[i,i+1]}))
    out+=$(printf '%02x' $(( b + (c - b) * weight / 100 )))
  done
  printf '\e]11;#%s\a' $out
}

add-zsh-hook chpwd _peacock_apply
_peacock_apply
