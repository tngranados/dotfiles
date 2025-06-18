# Install one or more versions of specified language
# e.g. `vmi rust` # => fzf multimode, tab to mark, enter to install
# if no plugin is supplied (e.g. `vmi<CR>`), fzf will list them for you
# Mnemonic [V]ersion [M]anager [I]nstall
vmi() {
  local lang

  lang=$(mise list | fzf --query "$1" -1)

  if [[ $lang ]]; then
    local versions=$(mise list-remote $lang | fzf --tac --no-sort --multi)
    if [[ $versions ]]; then
      for version in $(echo $versions);
      do; mise install $lang $version; done;
    fi
  fi
}

# Remove one or more versions of specified language
# e.g. `vmi rust` # => fzf multimode, tab to mark, enter to remove
# if no plugin is supplied (e.g. `vmi<CR>`), fzf will list them for you
# Mnemonic [V]ersion [M]anager [C]lean
vmc() {
  local lang

  lang=$(mise list | fzf --query "$1" -1)

  if [[ $lang ]]; then
    local versions=$(mise list $lang | fzf -m)
    if [[ $versions ]]; then
      for version in $(echo $versions);
      do; mise uninstall $lang $version; done;
    fi
  fi
}
