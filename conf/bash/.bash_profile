#!/usr/bin/env bash
# shellcheck disable=1090,1091

# Set up the shell for brew
eval "$(/opt/homebrew/bin/brew shellenv)"

# shellcheck disable=1090,1091
[ -f "${HOME}/.bash_profile.local" ] && source "${HOME}/.bash_profile.local"
