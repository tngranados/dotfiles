fkill() {
  local date ps target

  date=$(date)
  ps=$(ps -ef)
  target=$((echo "$date"; echo "$ps") |
    fzf --query "$1" --header=$'Press CTRL-R to reload\n\n' --header-lines=2 \
        --preview='echo {}' --preview-window=down,3,wrap \
        --height=80% | awk '{print $2}' | xargs kill -9)
}
