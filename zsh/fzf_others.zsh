fkill() {
  local date ps target

  date=$(date)
  ps=$(ps -ef)
  target=$((echo "$date"; echo "$ps") |
    fzf --query "$1" --header=$'Press CTRL-R to reload\n\n' --header-lines=2 \
        --preview='echo {}' --preview-window=down,3,wrap \
        --height=80% | awk '{print $2}' | xargs kill -9)
}

fvim() {
  local file

  file=$(fzf --query="$1" --preview="bat --theme-dark=Coldark-Dark --theme-light=GitHub --style=numbers --color=always {}" --preview-window=down:3:wrap --height=80%)
  [ -n "$file" ] && vim "$file"
}
