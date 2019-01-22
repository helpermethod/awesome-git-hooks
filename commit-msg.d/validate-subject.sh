#!/usr/bin/env bash

[[ $TRACE ]] && set -x

main() {
  local current_branch
  current_branch=$(git symbolic-ref -q --short HEAD)

  __is_detached && exit

  local commit_message_path=$1
  read -r header < "$commit_message_path"

  local issue_key=${current_branch#*/}

  [[ $header == *"$issue_key"* ]] && exit

  __prevent_commit "$issue_key"
}

__is_detached() {
  (($? > 0))
}

__prevent_commit() {
  declare red yellow_bold reset

  if [[ -t 1 ]]; then
    red=$(tput setaf 1)
    yellow_bold=$(tput setaf 3)$(tput bold)
    reset=$(tput sgr0)
  fi

  printf '%sThe subject line must contain the JIRA issue number %s(%s)%s%s.%s\n' "$red" "$yellow_bold" "$1" "$reset" "$red" "$reset" 2>&1
  exit 1
}

main "$@"
