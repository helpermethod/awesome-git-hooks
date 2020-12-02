#!/usr/bin/env bash

[[ $TRACE ]] && set -x

main() {
  local current_branch
  current_branch=$(git symbolic-ref --short HEAD)

  __is_detached && exit
  ! __is_blacklisted "$current_branch" && exit

  __prevent_commit "$current_branch"
}

__is_detached() {
  (($? > 0))
}

__is_blacklisted() {
  local blacklist=(develop main master)

  for branch in "${blacklist[@]}"; do
    [[ $branch = "$1" ]] && return
  done

  return 1
}

__prevent_commit() {
  local red yellow_bold reset

  if [[ -t 1 ]]; then
    red=$(tput setaf 1)
    yellow_bold=$(tput setaf 3)$(tput bold)
    reset=$(tput sgr0)
  fi

  printf '%sDirect commits to %s%s%s%s are not allowed.%s\n' "$red" "$yellow_bold" "$1" "$reset" "$red" "$reset" 2>&1

  exit 1
}

main
