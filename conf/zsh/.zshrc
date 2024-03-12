#!/usr/bin/env zsh
# shellcheck disable=1090,1091

# Get the target path of the .zshrc symlink.
MYDIR="$(dirname "$(readlink -f "${HOME}/.zshrc")")"

# Source the configs.
for f in "${MYDIR}"/configs/*.sh; do source "${f}"; done

# Source the functions.
for f in "${MYDIR}"/functions/*.sh; do source "${f}"; done

alias gam="/Users/john/bin/gam/gam"
alias devsetup="/Users/john/git/inversoft/fusionauth/fusionauth-developer/setup.sh"
