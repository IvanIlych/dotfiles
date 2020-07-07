#!/bin/bash

CWD=$(tmux display-message -p -F "#{pane_current_path}" -t0)
git_current_branch() {
  ref
  ref=$(command git symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  GIT_STATUS=""
  if [[ $ret != 0 ]]; then
    GIT_STATUS=""
    [[ $ret == 128 ]] && return  # no git repo.
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  fi
  REPO_NAME=$(basename $(git remote get-url origin) | sed 's/.git//')
  GIT_STATUS+=" $REPO_NAME"
  echo "$GIT_STATUS:${ref#refs/heads/}"
}
cd $CWD
if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
  if [[ "$(git config --get oh-my-zsh.hide-status 2>/dev/null)" = 2 ]]; then
    COLOUR=colour8
    GIT_STATUS+=" $(git_current_branch)"
    GIT_STATUS="#[fg=$COLOUR,bg=default]#[fg=black,bg=$COLOUR] $GIT_STATUS #[fg=black,bg=$COLOUR]#[fg=cyan,bg=default]#[fg=black,bg=cyan]"
    echo $GIT_STATUS
    exit 0
  fi
  COLOUR=green
  GIT_STATUS+=" $(git_current_branch)"
  repo_path=$(git rev-parse --git-dir 2>/dev/null)
  STATUS_MSG=$(git status --porcelain)
  if [[ $STATUS_MSG ]]; then
     COLOUR=yellow
     if [[ ! -z $(echo $STATUS_MSG | grep 'M ' ) ]]; then
       GIT_STATUS+=" ﯂"
     fi
     if [[ ! -z $(echo $STATUS_MSG | grep '??' ) ]]; then
       GIT_STATUS+=" "
     fi
  fi

  if [[ -e "${repo_path}/BISECT_LOG" ]]; then
    GIT_STATUS+=" <B>"
    COLOUR=red
  elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
    GIT_STATUS+=" >M<"
    COLOUR=red
  elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
    GIT_STATUS+=" >R>"
    COLOUR=red
  fi
  # if [[ ! -z $(git status -sb | grep ahead) ]]; then
  #   GIT_STATUS+=' '
  # else
  #   if [ ! $(git rev-parse HEAD) = $(git ls-remote $(git rev-parse --abbrev-ref @{u} | sed 's/\// /g') | cut -f1) ]; then
  #     GIT_STATUS+=" "
  #   fi
  # fi
  GIT_STATUS="#[fg=$COLOUR,bg=default]#[fg=black,bg=$COLOUR] $GIT_STATUS #[fg=black,bg=$COLOUR]#[fg=cyan,bg=default]#[fg=black,bg=cyan]"
else
  COLOUR=cyan
  GIT_STATUS="#[fg=$COLOUR,bg=default]"
fi
echo $GIT_STATUS
