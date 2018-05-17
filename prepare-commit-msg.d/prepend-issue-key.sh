#!/usr/bin/env bash

[[ $TRACE ]] && set -x

main() {
  local current_branch=$(git rev-parse --abbrev-ref HEAD)
  local commit_message_path=$1

  [[ $current_branch = HEAD ]] && exit

  [[ $2 ]] && exit 

  __prepend "$current_branch " "$commit_message_path"
}

__prepend() {
  printf '%s%s' "$1" "$(< $2)" > "$2"
}

main "$@"
