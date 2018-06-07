#!/usr/bin/env bash

[[ $TRACE ]] && set -x

main() {
  local current_branch
  current_branch=$(git symbolic-ref -q --short HEAD)

  (($? > 0)) && exit

  local commit_message_path=$1
  local commit_message_source=$2

  [[ $commit_message_source ]] && exit 

  local issue_key=${current_branch#*/}

  __prepend "$issue_key " "$commit_message_path"
}

__prepend() {
  printf '%s%s' "$1" "$(< $2)" > "$2"
}

main "$@"
