# Docker
dockerrmf() {
  docker rm -vf $(docker ps -a -q)
}
dockerrmif() {
  docker rmi -f $(docker images -a -q)
}

# Git rebase progress
rprogress() {
  local RMD=$(git rev-parse --git-path 'rebase-merge/')
  local N=$(cat "${RMD}msgnum")
  local L=$(cat "${RMD}end")
  echo "${N}/${L}"
}

# Grep something over a git repository currently modified or added files. First paremter is the search term, the rest of
# them are regexp of ignored files.
gitg() {
  local term=$1

  shift
  local ignored_files=${(j:|:)${@}}

  git status --porcelain | awk 'match($1, "A|M"){print $2}' | rg -v "${ignored_files:-_}" | xargs rg $term
}

# Help stuff
cheat() {
  curl "https://cheat.sh/$1"
}
remove-tonidebug() {
  rg "tonidebug" . --files-with-matches | xargs sed -i '' '/tonidebug/d'
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

get-uuid() {
    system_profiler SPUSBDataType | sed -n -e '/iPad/,/Serial/p' -e '/iPhone/,/Serial/p'
}

plain-clipboard() {
    pbpaste | textutil -convert txt -stdin -stdout -encoding 30 | pbcopy
}

preman() {
    mandoc -T pdf "$(/usr/bin/man -w $@)" | open -fa Preview
}

copy-pr() {
    gh pr view --json url -q ".url" | pbcopy
}

update_code_agents() {
  local exit_code=0
  local npm_packages=(
    "@openai/codex@latest"
    "@github/copilot@latest"
    "cline"
  )

  if command -v npm >/dev/null 2>&1; then
    for pkg in "${npm_packages[@]}"; do
      echo "==> npm install -g ${pkg}"
      if ! npm install -g "${pkg}"; then
        echo "!! Failed to update ${pkg}"
          exit_code=1
      fi
    done
  else
    echo "npm not found; skipping npm-based agent updates."
  fi

  if command -v claude >/dev/null 2>&1; then
    echo "==> claude update"
    if ! claude update; then
      echo "!! Failed to update Claude CLI"
      exit_code=1
    fi
  else
    echo "claude CLI not found; skipping Claude update."
  fi

  return $exit_code
}

# Retries a command a with backoff.
#
# The retry count is given by ATTEMPTS (default 100), the
# initial backoff timeout is given by TIMEOUT in seconds
# (default 5), or the second argument to the function.
#
# Successive backoffs increase the timeout by ~33%.
#
# Beware of set -e killing your whole script!
retry() {
  local cmd="$1"
  local initial_wait=${TIMEOUT-"$2"}
  local max_retries=${ATTEMPTS-100}
  local attempt=1
  local wait_time=${initial_wait}

  if [ -z "$cmd" ] || [ -z "$initial_wait" ]; then
    echo "Usage: retry_with_exp_backoff <command> <initial_wait_time>"
    return 1
  fi

  while true; do
    echo "Attempt #$attempt:"
    if eval "$cmd"; then
      echo "Command succeeded."
      break
    else
      if [ "$attempt" -ge "$max_retries" ]; then
        echo "Max retries reached. Command failed."
        return -1
      else
        echo "Command failed. Retrying in $(printf "%.2f" $wait_time) seconds..."
        sleep $wait_time
        wait_time=$((wait_time * 1.33))
        attempt=$((attempt + 1))
      fi
    fi
  done
}

mkcd () {
  \mkdir -p "$1"
  cd "$1"
}

# Show help for custom dotfiles commands
dothelp() {
  echo "\033[1mCustom Commands:\033[0m"
  echo "  cheat <topic>       Get cheatsheet from cheat.sh"
  echo "  mkcd <dir>          Create and cd into directory"
  echo "  tempe [dir]         Create temp directory and cd into it"
  echo "  retry <cmd> <sec>   Retry command with exponential backoff"
  echo "  shttp [port]        Start simple HTTP server (default: 8000)"
  echo "  boop                Play sound based on last command status"
  echo "  plain-clipboard     Convert clipboard to plain text"
  echo "  preman <cmd>        Open man page as PDF in Preview"
  echo "  copy-pr             Copy current PR URL to clipboard"
  echo ""
  echo "\033[1mFZF Commands:\033[0m (run 'fzfgit' for git-specific)"
  echo "  fkill [query]       Fuzzy kill processes"
  echo "  fvim [query]        Fuzzy find and open file in vim"
  echo "  fco [query]         Fuzzy checkout git branch/tag"
  echo "  flog                Browse git commits"
  echo "  fstash              Browse and manage git stashes"
  echo ""
  echo "\033[1mMise Commands:\033[0m"
  echo "  vmi [lang]          Install language versions"
  echo "  vmc [lang]          Remove language versions"
}

tempe () {
  cd "$(mktemp -d)"
  chmod -R 0700 .
  if [[ $# -eq 1 ]]; then
    \mkdir -p "$1"
    cd "$1"
    chmod -R 0700 .
  fi
}
