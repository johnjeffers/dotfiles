#!/usr/bin/env bash

# Set up the shell for brew
eval "$(/opt/homebrew/bin/brew shellenv)"

# fusionauth-developer setup script stuff
export PATH=$PATH:/opt/fusionauth/bin
export JAVA_HOME=/opt/fusionauth/apps/java/current17
eval "$(rbenv init - zsh)"
export PATH=$PATH:/Users/john/git/inversoft/libraries/inversoft-scripts/src/main/ruby
alias devsetup="/Users/john/git/inversoft/fusionauth/fusionauth-developer/setup.sh"
alias ssologin='aws sso login --profile ${SSO_PROFILE:-fusionauth-dev}'
alias ecrlogin='aws ecr get-login-password --profile ${SSO_PROFILE:-fusionauth-dev} | docker login --username AWS --password-stdin 752443094709.dkr.ecr.us-west-2.amazonaws.com'
