#!/usr/bin/env bash

BREW_TMUX_CASK_ICON="${BREW_TMUX_CASK_ICON:-}"
BREW_TMUX_FORMULAE_ICON="${BREW_TMUX_FORMULAE_ICON:-}"
BREW_TMUX_SEPARATOR="${BREW_TMUX_SEPARATOR:-  }"
BREW_TMUX_CACHE_FILE="${BREW_TMUX_CACHE_FILE:-/tmp/brew_tmux_outdated.json}"
BREW_TMUX_CHECK_SECONDS="${BREW_TMUX_CHECK_SECONDS:-3600}"

_brew_tmux_check_command() {
  command -v $1 >/dev/null
}

_brew_tmux_outdated_command() {
  brew outdated --json --greedy >$BREW_TMUX_CACHE_FILE
}

_brew_tmux_outdated_count() {

  jq ".$1 | length" $BREW_TMUX_CACHE_FILE
}

_brew_tmux_outdated_cached() {
  if ! test -f $BREW_TMUX_CACHE_FILE; then
    _brew_tmux_outdated_command
  fi

  local FILETIME="$(stat -t %s -f %m $BREW_TMUX_CACHE_FILE)"
  local CURTIME=$(date +%s)
  local DIFFTIME=$(($CURTIME - $FILETIME))

  # outdated packages cache will be generated after 60 minutes
  if test $DIFFTIME -gt $BREW_TMUX_CHECK_SECONDS; then
    _brew_tmux_outdated_command
  fi
}

brew_tmux() {
  if ! _brew_tmux_check_command "brew"; then return; fi
  if ! _brew_tmux_check_command "jq"; then
    echo "jq is required"
    return
  fi

  _brew_tmux_outdated_cached

  local CASKS_COUNT="$(_brew_tmux_outdated_count 'casks')"
  local FORMULAE_COUNT="$(_brew_tmux_outdated_count 'formulae')"
  local BREW_TMUX

  BREW_TMUX+="${BREW_TMUX_FORMULAE_ICON} ${FORMULAE_COUNT}${BREW_TMUX_SEPARATOR}${BREW_TMUX_CASK_ICON} ${CASKS_COUNT}"

  echo "${BREW_TMUX}"
}

brew_tmux "$@"
