#!/usr/bin/env bash
# I don't use bash much, but if I need to, let's have a nice looking prompt.

# MacOS warns you if you're using bash. Turn that off.
export BASH_SILENCE_DEPRECATION_WARNING=1

eval "$(starship init bash)"

# shellcheck disable=1090,1091
[ -f "${HOME}/.bashrc.local" ] && source "${HOME}/.bashrc.local"
