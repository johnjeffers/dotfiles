#!/usr/bin/env bash

# Set up the shell for brew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Added by fusionauth-developer setup script
if [[ -d "$HOME/.pyenv" ]]; then
  export PATH=$PATH:/opt/fusionauth/bin
  export JAVA_HOME=/opt/fusionauth/apps/java/current17
  eval "$(rbenv init - zsh)"
  export PATH=$PATH:/Users/john/git/inversoft/libraries/inversoft-scripts/src/main/ruby
fi
