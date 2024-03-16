#!/usr/bin/env bash

# Set up the shell for brew
eval "$(/opt/homebrew/bin/brew shellenv)"

# fusionauth-developer setup script stuff
if [[ -d "/opt/fusionauth" ]]; then
  export PATH=$PATH:/opt/fusionauth/bin
fi
if [[ -L "/opt/fusionauth/apps/java/current17" ]]; then
  export JAVA_HOME=/opt/fusionauth/apps/java/current17
fi
if [[ -d "$HOME/.rbenv" ]]; then
  eval "$(rbenv init - zsh)"
  export PATH=$PATH:/Users/john/git/inversoft/libraries/inversoft-scripts/src/main/ruby
fi
