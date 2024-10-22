#!/usr/bin/env zsh

# Does a git pull for every subdir in a directory.
# Handy for making sure a bunch of repos are up-to-date with one command.
function git-pull-dirs() {
  startdir=$(pwd)

  # Find any directory that contains a .git directory.
  paths=()
  while IFS='' read -r line; do paths+=("$line"); done < <(find ~+ -path "*/.git" | sort)

  for p in "${paths[@]}"; do
    # Strip the .git directory from the path.
    d="${p%\/.git}"

    # Skip terraform modules
    if [[ $p == *"terraform"* ]]; then
      continue
    fi

    echo ""
    echo "checking ${d#"$startdir"}..."

    cd "${d}" || return
    # Switch to main if we're not already using it...
    if [[ $(git branch --show-current) != $(git_main_branch) ]]; then
      git switch "$(git_main_branch)"
    fi
    # ...then pull everything.
    git pull --all
  done

  cd "$startdir" || return
}

GIT_HASH="%C(always,yellow)%h%C(always,reset)"
GIT_REL_TIME="%C(always,green)%ar%C(always,reset)"
GIT_AUTHOR="%C(always,bold blue)%an%C(always,reset)"
GIT_REFS="%C(always,red)%d%C(always,reset)"
GIT_SUBJECT="%s"

GIT_LOG_FORMAT="$GIT_HASH $GIT_REL_TIME{$GIT_AUTHOR{$GIT_REFS $GIT_SUBJECT"

function git-pretty-log() {
  git log --graph --pretty="tformat:$GIT_LOG_FORMAT" $* |
    column -t -s '{' |
    less -XRS --quit-if-one-screen
}
