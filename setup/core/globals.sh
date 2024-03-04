#!/usr/bin/env bash
# shellcheck disable=SC2034

### Colors

GRAY=$(tput setaf 248)
GREEN=$(tput setaf 2)
RED=$(tput setaf 202)
RESET=$(tput sgr0)
YELLOW=$(tput setaf 228)

### Script Stuff

# Verbosity settings
DEBUG=false
VERBOSE=false
# FLAGFILE tracks whether the script has completed its first run.
FLAGFILE="${MYDIR}/.first_run"
# Brew's root directory. This is /usr/local on x64
BREWDIR="/opt/homebrew"
# This array is used when the --all flag is passed.
MODULES=(
  # prereqs
  brew
  # ohmyzsh
  # OS stuff
  # oneshot  # only run once
  hosts    # only run once
  # shells
  bash
  zsh
  starship
  # app configs
  ssh
  git
  aws
  iterm
  python
)

### Defaults for vars that will be set in .env

# Git - repo locations
# Don't quote these values if you're using ~ for home dir expansion!
MY_REPOS="${HOME}/git/personal"
PUBLIC_REPOS="${HOME}/git/public"
WORK_REPOS="${HOME}/git/mycompany"
# Git - default global config
MY_NAME=""
MY_EMAIL=""
# Git - public config
PUBLIC_NAME=""
PUBLIC_EMAIL=""
# Git - work config
WORK_NAME=""
WORK_EMAIL=""
# Brewfiles
BREW_BASE=false
BREW_HOME=false
BREW_MUSIC=false
BREW_WORK=false
