#!/usr/bin/env zsh
# shellcheck disable=1090,1091

### This file does nothing except source files that actually contain configs.

# Get the target path of the .zshrc symlink.
MY_DIR="$(dirname "$(readlink -f "${HOME}/.zshrc")")"

# Source the configs.
for f in "${MY_DIR}"/configs/*.sh; do source "${f}"; done

# Source the functions.
for f in "${MY_DIR}"/functions/*.sh; do source "${f}"; done

# Added by fusionauth-developer setup script
#
# Make sure these values are in the script's .env file
# so it doesn't write new values.
#
# REPODIR="${HOME}/git/inversoft"
# INSTDIR="/opt/fusionauth/apps"
# BINDIR="/opt/fusionauth/bin"
export PATH=$PATH:/opt/homebrew/bin
export PATH=$PATH:/opt/fusionauth/bin
export JAVA_HOME=/Users/john/dev/java/current17
eval "$(rbenv init - zsh)"
alias devsetup="/Users/john/git/inversoft/fusionauth/fusionauth-developer/setup.sh"
