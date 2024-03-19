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
alias ssologin='aws sso login --profile ${SSO_PROFILE:-fusionauth-dev}'
alias ecrlogin='aws ecr get-login-password --profile ${SSO_PROFILE:-fusionauth-dev} | docker login --username AWS --password-stdin 752443094709.dkr.ecr.us-west-2.amazonaws.com'
