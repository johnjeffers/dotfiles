#!/usr/bin/env zsh
# shellcheck disable=1090,1091

### This file does nothing except source files that actually contain configs.

# Get the target path of the .zshrc symlink.
MY_DIR="$(dirname "$(readlink -f "${HOME}/.zshrc")")"

# Source the configs.
for f in "${MY_DIR}"/configs/*.sh; do source "${f}"; done

# Source the functions.
for f in "${MY_DIR}"/functions/*.sh; do source "${f}"; done
