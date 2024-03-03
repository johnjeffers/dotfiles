#!/usr/bin/env bash
# shellcheck disable=SC2034


### Colors

GRAY=$(tput setaf 248)
GREEN=$(tput setaf 2)
RED=$(tput setaf 202)
RESET=$(tput sgr0)
YELLOW=$(tput setaf 228)


### Script verbosity

DEBUG=false
VERBOSE=false


### Stuff that should be overridden in an env file

# TODO - prompt for this stuff and manage the env file

# Git - repo locations
# Don't quote these values if you're using ~ for home dir expansion!
MY_REPOS=~/git/personal
PUBLIC_REPOS=~/git/public
WORK_REPOS=~/mycompany

# Git - default global config
MY_NAME=""
MY_EMAIL=""

# Git - public config
PUBLIC_NAME=""
PUBLIC_EMAIL=""

# Git - work config
WORK_NAME=""
WORK_EMAIL=""

# Use brew?
RUN_BREW=true
# Use brewfiles? Ignored if RUN_BREW=false
BREW_BASE=false
BREW_HOME=false
BREW_MUSIC=false
BREW_WORK=false

# Run script sections?
SETUP_BASH=true
SETUP_ZSH=true
SETUP_STARSHIP=true
SETUP_SSH=true
SETUP_AWS=true
SETUP_GIT=true
SETUP_ITERM=true
SETUP_PYTHON=true


MODULES=(
  # prereqs
  brew
  ohmyzsh
  # system stuff
  # oneshot  # only run once
  #  hosts  # only run once
  # shells
  bash
  zsh
  starship
  # app configs
  aws
  git
  iterm
  python
  ssh
)