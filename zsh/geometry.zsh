# Overrides geometry's async RPROMPT: upstream reads the newest job's fd from every
# handler, so an overlapping stale job steals the output and leaves RPROMPT empty.

(( $+functions[geometry::rprompt] )) || return

zmodload zsh/datetime

geometry::rprompt::set() {
  local fd=$1
  [[ -z $2 || $2 == hup ]] && read -r -u $fd RPROMPT && zle reset-prompt
  zle -F $fd
  exec {fd}<&-
  unset GEOMETRY_ASYNC_FD
}

geometry::rprompt() {
  if [[ -n $GEOMETRY_ASYNC_FD ]]; then
    zle -F $GEOMETRY_ASYNC_FD
    exec {GEOMETRY_ASYNC_FD}<&-
  fi
  RPROMPT=
  exec {GEOMETRY_ASYNC_FD}< <(geometry::wrap $PWD $GEOMETRY_RPROMPT)
  zle -F $GEOMETRY_ASYNC_FD geometry::rprompt::set
}

# Same output as upstream geometry_git from one `git status` instead of ~13 git calls.
# --no-optional-locks keeps the async prompt from racing foreground git for index.lock.
geometry_git() {
  local st
  if ! st=$(command git --no-optional-locks status --porcelain=v2 --branch --show-stash --ignore-submodules 2>/dev/null); then
    [[ $(command git rev-parse --is-bare-repository 2>/dev/null) == true ]] \
      && ansi ${GEOMETRY_GIT_COLOR_BARE:-blue} ${GEOMETRY_GIT_SYMBOL_BARE:-⬢}
    return
  fi

  local line oid head file
  local -i tracked=0 ahead=0 behind=0 stashes=0 dirty=0 markers=0
  local -a conflicted out
  for line in ${(f)st}; do
    case $line in
      '# branch.oid '*) oid=${line#\# branch.oid } ;;
      '# branch.head '*) head=${line#\# branch.head } ;;
      '# branch.ab '*) tracked=1; ahead=${${line#\# branch.ab +}%% *}; behind=${line##*-} ;;
      '# stash '*) stashes=${line#\# stash } ;;
      '#'*) ;;
      'u '*) dirty=1; conflicted+=("${(j: :)${(s: :)line}[11,-1]}") ;;
      *) dirty=1 ;;
    esac
  done

  if [[ $head == '(detached)' ]]; then
    local git_dir=$(command git rev-parse --git-dir)
    [[ -d $git_dir/rebase-merge || -d $git_dir/rebase-apply ]] && out+=${GEOMETRY_GIT_SYMBOL_REBASE:-®}
    head=${oid[1,7]}
  fi

  local unpushed=${GEOMETRY_GIT_SYMBOL_UNPUSHED:-⇡} unpulled=${GEOMETRY_GIT_SYMBOL_UNPULLED:-⇣}
  if (( ahead && behind )); then
    out+="$unpushed $unpulled"
  elif (( ahead )) || { (( ! tracked )) && [[ $oid != '(initial)' ]] }; then
    out+=$unpushed
  elif (( behind )); then
    out+=$unpulled
  fi

  out+="%F{${GEOMETRY_GIT_COLOR_BRANCH:-242}}${head//\%/%%}%f"

  if (( $#conflicted )); then
    for file in $conflicted; do
      [[ -r $file ]] && markers+=${#${(M)${(f)"$(<$file)"}:#=======}}
    done
    if (( markers )); then
      out+="%F{${GEOMETRY_GIT_COLOR_CONFLICTS_UNSOLVED:-red}}${GEOMETRY_GIT_SYMBOL_CONFLICTS_UNSOLVED:-◈} (${#conflicted}f|${markers}c)%f"
    else
      out+="%F{${GEOMETRY_GIT_COLOR_CONFLICTS_SOLVED:-green}}${GEOMETRY_GIT_SYMBOL_CONFLICTS_SOLVED:-◆}%f"
    fi
  fi

  if [[ $oid == '(initial)' ]]; then
    out+="%F{${GEOMETRY_COLOR_NO_TIME:-default}}${GEOMETRY_GIT_NO_COMMITS_MESSAGE:-welcome}%f"
  else
    out+=$(geometry::time $(( EPOCHSECONDS - $(command git log -1 --format=%at) )) ${GEOMETRY_GIT_TIME_DETAILED:-false})
  fi

  (( stashes )) && out+="%F{${GEOMETRY_GIT_COLOR_STASHES:-144}}${GEOMETRY_GIT_SYMBOL_STASHES:-●}%f"

  if (( dirty )); then
    out+="%F{${GEOMETRY_GIT_COLOR_DIRTY:-red}}${GEOMETRY_GIT_SYMBOL_DIRTY:-⬡}%f"
  else
    out+="%F{${GEOMETRY_GIT_COLOR_CLEAN:-green}}${GEOMETRY_GIT_SYMBOL_CLEAN:-⬢}%f"
  fi

  print -rn -- "${(ej.${GEOMETRY_SEPARATOR:- }.)out}"
}

# Fork-free equivalents of upstream's title hooks for the default titles with GEOMETRY_PATH_SHOW_BASENAME
geometry::set_title() {
  print -rn -- $'\e]1;'"${PWD:t}"$'\a'
}

geometry::set_cmdtitle() {
  GEOMETRY_LAST_COMMAND=$2
  print -rn -- $'\e]1;'"$2 $USER@${HOST:-$HOSTNAME}"$'\a'
}
