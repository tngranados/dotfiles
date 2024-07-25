# fzfgit - shows a list of the following functions
fzfgit() {
  function echo_color() {
    local fn="$1"
    local desc="$2"
    local color="\033[0;90m"
    printf "${fn}: ${color}${desc}\033[0m\n"
  }
  echo_color "fbr" "checkout git branch (including remote branches)"
  echo_color "fco" "checkout git branch/tag, automatically checkouts if only one branch/tag"
  echo_color "fco_preview" "checkout git branch/tag with preview"
  echo_color "flog" "git commit browser"
  echo_color "fcoc" "checkout git commit"
  echo_color "fcs" "get git commit sha (ex: git rebase -i \`fcs\`)"
  echo_color "fstash" "list stashes - enter shows content, C-d diff against HEAD, C-b checks as branch"
  echo_color "ftags" "search ctags"
}

# fbr - checkout git branch (including remote branches)
fbr() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux --query "$1" -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# fco - checkout git branch/tag
fco() {
    local tags branches tagsAndBranches exact_match target

    tags=$(git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}') || return
    branches=$(git branch --all | grep -v HEAD | sed "s/.* //" | sed "s#remotes/[^/]*/##" | sort -u | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return
    tagsAndBranches=$(echo "$tags"; echo "$branches")

    exact_match=$(echo "$tagsAndBranches" | awk -v query="$1" -F"\t" '$2 == query {print $2}')

    # If there's an exact match, check it out directly
    if [ -n "$exact_match" ]; then
        git checkout "$1"
        return
    fi

    # If there is only one match, check it out directly
    if [ $(echo "$tagsAndBranches" | wc -l) -eq 1 ]; then
        git checkout $(echo "$tagsAndBranches" | awk -F"\t" '{print $2}')
        return
    fi

    preview_cmd='
    if [[ {1} == branch ]]; then
        git log -1 --pretty=format:"%C(yellow)%h%C(reset) %s %C(cyan)(%cr)%C(reset)%n%C(green)Author: %an%C(reset)" --color=always {2}
    else
        git show --pretty=format:"%C(yellow)%h%C(reset) %s %C(cyan)(%cr)%C(reset)%n%C(green)Author: %an%C(reset)" --color=always --no-patch {2}
    fi'

    target=$(
        (echo "$tagsAndBranches") |
        fzf -1 --query "$1" --preview="$preview_cmd" --preview-window=down:3:wrap --no-hscroll --ansi +m -n 2
    ) || return

    git checkout $(echo "$target" | awk -F"\t" '{print $2}')
}

# fco_preview - checkout git branch/tag, with a preview showing the commits between the tag/branch and HEAD
fco_preview() {
  local tags branches target
  branches=$(
    git --no-pager branch --all \
      --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" \
    | sed '/^$/d') || return
  tags=$(
    git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || return
  target=$(
    (echo "$branches"; echo "$tags") |
    fzf --query "$1" --no-hscroll --no-multi -n 2 \
        --ansi --preview="git --no-pager log -150 --pretty=format:%s '..{2}'") || return
  git checkout $(awk '{print $2}' <<<"$target" )
}

# flog - git commit browser
flog() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --query "$1"  --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

# fcoc - checkout git commit
fcoc() {
  local commits commit
  commits=$(git log --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --query "$1" --tac +s +m -e) &&
  git checkout $(echo "$commit" | sed "s/ .*//")
}

# fcs - get git commit sha
# example usage: git rebase -i `fcs`
fcs() {
  local commits commit
  commits=$(git log --color=always --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --query "$1" --tac +s +m -e --ansi --reverse) &&
  echo -n $(echo "$commit" | sed "s/ .*//")
}

# fstash - easier way to deal with stashes
# type fstash to get a list of your stashes
# enter shows you the contents of the stash
# ctrl-d shows a diff of the stash against your current HEAD
# ctrl-b checks the stash out as a branch, for easier merging
fstash() {
  local out q k sha
  q="$1"
  while out=$(
    git stash list --pretty="%C(yellow)%h %>(14)%Cgreen%cr %C(blue)%gs" |
    fzf --ansi --no-sort --query="$q" --print-query \
        --expect=ctrl-d,ctrl-b);
  do
    # mapfile -t out <<< "$out" # Bash only
    out=("${(f)$(<<< "$out")}") # Zsh alternative
    q="${out[0]}"
    k="${out[1]}"
    sha="${out[-1]}"
    sha="${sha%% *}"
    [[ -z "$sha" ]] && continue
    if [[ "$k" == 'ctrl-d' ]]; then
      git diff $sha
    elif [[ "$k" == 'ctrl-b' ]]; then
      git stash branch "stash-$sha" $sha
      break;
    else
      git stash show -p $sha
    fi
  done
}

# ftags - search ctags
ftags() {
  local line
  [ -e tags ] &&
  line=$(
    awk 'BEGIN { FS="\t" } !/^!/ {print toupper($4)"\t"$1"\t"$2"\t"$3}' tags |
    cut -c1-80 | fzf --query "$1" --nth=1,2
  ) && $EDITOR $(cut -f3 <<< "$line") -c "set nocst" \
                                      -c "silent tag $(cut -f2 <<< "$line")"
}

# Based on: https://gist.github.com/dac09/97b9038e62299eed76ee18a782e3f3b9
