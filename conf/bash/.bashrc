#!/usr/bin/env bash
# I don't use bash much, but if I need to, let's have a nice looking prompt.

# MacOS warns you if you're using bash. Turn that off.
export BASH_SILENCE_DEPRECATION_WARNING=1

eval "$(starship init bash)"

# Added by fusionauth-developer setup script
#
# Make sure these values are in the script's .env file
# so it doesn't write new values.
#
# REPODIR="${HOME}/git/inversoft"
# INSTDIR="/opt/fusionauth/apps"
# BINDIR="/opt/fusionauth/bin"
if [[ -d "/opt/fusionauth" ]]; then
  export PATH=$PATH:/opt/fusionauth/bin
  export JAVA_HOME=/opt/fusionauth/apps/java/current17
  eval "$(rbenv init - zsh)"
  export PATH=$PATH:/Users/john/git/inversoft/libraries/inversoft-scripts/src/main/ruby
  alias devsetup="/Users/john/git/inversoft/fusionauth/fusionauth-developer/setup.sh"
  alias ssologin='aws sso login --profile ${SSO_PROFILE:-fusionauth-dev}'
  alias ecrlogin='aws ecr get-login-password --profile ${SSO_PROFILE:-fusionauth-dev} | docker login --username AWS --password-stdin 752443094709.dkr.ecr.us-west-2.amazonaws.com'
fi
