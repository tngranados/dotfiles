# Overrides geometry's async RPROMPT: upstream reads the newest job's fd from every
# handler, so an overlapping stale job steals the output and leaves RPROMPT empty.

(( $+functions[geometry::rprompt] )) || return

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
