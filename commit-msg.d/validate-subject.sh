#!/usr/bin/env bash

[[ $TRACE ]] && set -x

main() {
  local current_branch=$(git rev-parse --abbrev-ref HEAD)
  local commit_message_path=$1

  [[ $current_branch = HEAD ]] && exit

  local issue_key=${current_branch#*/}
  read -r header < "$commit_message_path"

  [[ $header == *"$issue_key"* ]] && exit

  __prevent_commit "$issue_key"
}

__prevent_commit() {
  local red=$(tput setaf 1) 
  local yellow_bold=$(tput setaf 3)$(tput bold)
  local reset=$(tput sgr0)

  printf '%sThe subject line must contain the JIRA issue key %s(%s)%s%s.%s\n' "$red" "$yellow_bold" "$1" "$reset" "$red" "$reset" 2>&1
  exit 1
}

main "$@"
