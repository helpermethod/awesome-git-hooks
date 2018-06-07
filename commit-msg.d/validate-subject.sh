#!/usr/bin/env bash

[[ $TRACE ]] && set -x

main() {
  local current_branch=$(git rev-parse --abbrev-ref HEAD)
  local commit_message_path=$1

  [[ $current_branch = HEAD ]] && exit

  read -r header < "$commit_message_path"

  [[ $header == *"$current_branch"* ]] && exit

  __prevent_commit "$current_branch"
}

__prevent_commit() {
  local red=$(tput setaf 1) 
  local yellow_bold=$(tput setaf 3)$(tput bold)
  local reset=$(tput sgr0)

  printf '%sThe subject line must contain the name of the current branch %s(%s)%s%s.%s\n' "$red" "$yellow_bold" "$1" "$reset" "$red" "$reset" 2>&1
  exit 1
}

main "$@"
