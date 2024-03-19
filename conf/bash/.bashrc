#!/usr/bin/env bash
# I don't use bash much, but if I need to, let's have a nice looking prompt.

# MacOS warns you if you're using bash. Turn that off.
export BASH_SILENCE_DEPRECATION_WARNING=1

eval "$(starship init bash)"

alias gam="/Users/john/bin/gam/gam"
alias devsetup="/Users/john/git/inversoft/fusionauth/fusionauth-developer/setup.sh"
alias ssologin='aws sso login --profile ${SSO_PROFILE:-fusionauth-dev}'
alias ecrlogin='aws ecr get-login-password --profile ${SSO_PROFILE:-fusionauth-dev} | docker login --username AWS --password-stdin 752443094709.dkr.ecr.us-west-2.amazonaws.com'
