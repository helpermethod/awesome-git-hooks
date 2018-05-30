#!/usr/bin/env bash

[[ $TRACE ]] && set -x

main() {
  local current_branch=$(git rev-parse --abbrev-ref HEAD)
  local commit_message_path=$1
  local commit_message_source=$2

  [[ $current_branch = HEAD ]] && exit

  [[ $commit_message_source ]] && exit 

  local issue_key=${current_branch#*/}

  __prepend "$issue_key " "$commit_message_path"
}

__prepend() {
  printf '%s%s' "$1" "$(< $2)" > "$2"
}

main "$@"
