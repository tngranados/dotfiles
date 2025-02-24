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
    local tags branches local_branches remote_branches tagsAndBranches exact_match target selected

    # Function to output colored tags
    get_tags() {
        git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}'
    }

    # Function to output colored local branches
    get_local_branches() {
        git for-each-ref --format='%(refname:short)' refs/heads/ | sort | awk '{print "\x1b[34;1mlocal\x1b[m\t" $1}'
    }

    # Function to output colored remote branches
    get_remote_branches() {
        git for-each-ref --format='%(refname:short)' refs/remotes/ | sort | awk '{print "\x1b[34;1mremote\x1b[m\t" $1}'
    }

    # Fetch tags and branches
    tags=$(get_tags) || { echo "Failed to retrieve tags."; return 1; }
    local_branches=$(get_local_branches) || { echo "Failed to retrieve local branches."; return 1; }
    remote_branches=$(get_remote_branches) || { echo "Failed to retrieve remote branches."; return 1; }

    # Combine tags and branches, prioritizing local branches
    tagsAndBranches=$(echo "$local_branches"; echo "$remote_branches"; echo "$tags")

    # Check for exact match
    exact_match=$(echo "$tagsAndBranches" | awk -v query="$1" -F"\t" '$2 == query {print $2}')

    if [[ -n "$exact_match" ]]; then
        git checkout "$1" && return
        echo "Failed to checkout '$1'. Please ensure it exists."
        return 1
    fi

    # Check if there's only one match
    local count
    count=$(echo "$tagsAndBranches" | wc -l)
    if [[ "$count" -eq 1 ]]; then
        local single_target
        single_target=$(echo "$tagsAndBranches" | awk -F"\t" '{print $2}')
        git checkout "$single_target" && return
        echo "Failed to checkout '$single_target'. Please ensure it exists."
        return 1
    fi

    # Enhanced preview command with additional context
    local preview_cmd="
        ref=\$(echo {} | awk '{print \$2}');
        if git show-ref --verify --quiet refs/heads/\$ref || git show-ref --verify --quiet refs/remotes/*/\$ref || git show-ref --verify --quiet refs/tags/\$ref; then
            git log -n 5 --color=always --pretty=format:'%C(yellow)%h %C(cyan)%ar %C(blue)<%an> %C(auto)%d %C(reset)%s' \$ref;
            echo '\n--------STATS-----------';
            git show --color=always --stat \$ref | head -n 5;
            if [ \$(git rev-parse --is-inside-work-tree 2>/dev/null) ]; then
            echo '\n--------DIFF-----------';
                git diff --color=always HEAD...\$ref -- . | head -n 20;
            fi;
        else
            echo 'Reference not found';
        fi"

    # Invoke fzf with improved options
    target=$(
        echo "$tagsAndBranches" |
        fzf --height 60% \
            --layout=reverse \
            --border \
            --prompt="Checkout> " \
            --info=inline \
            --preview="$preview_cmd" \
            --preview-window=down:40%:wrap \
            --no-hscroll \
            --ansi
    ) || return

    git checkout $(echo "$target" | awk -F"\t" '{print $2}')

    # Extract the target branch or tag
    selected=$(echo "$target" | awk -F"\t" '{print $2}')

    # Attempt to checkout the selected branch or tag
    if git checkout "$selected"; then
        echo "Checked out '$selected' successfully."
    else
        echo "Failed to checkout '$selected'. Please ensure it exists."
        return 1
    fi
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
