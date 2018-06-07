#!/usr/bin/env bash

[[ $TRACE ]] && set -x

main() {
  local current_branch
  current_branch=$(git symbolic-ref --short HEAD)

  (($? > 0)) && exit

  ! __is_blacklisted "$current_branch" && exit

  __prevent_commit "$current_branch"
}

__is_blacklisted() {
  local blacklist=(develop master)

  for branch in "${blacklist[@]}"; do
    [[ $branch = "$1" ]] && return
  done

  return 1
}

__prevent_commit() {
  local red=$(tput setaf 1)
  local yellow_bold=$(tput setaf 3)$(tput bold)
  local reset=$(tput sgr0)

  printf '%sDirect commits to %s%s%s%s are not allowed.%s\n' "$red" "$yellow_bold" "$1" "$reset" "$red" "$reset" 2>&1

  exit 1
}

main
