#!/usr/bin/env zsh

# Set up the shell for brew.
eval "$(/opt/homebrew/bin/brew shellenv)"

# fusionauth-developer setup script stuff
export PATH=$PATH:/opt/fusionauth/bin
export PATH=$PATH:/Users/john/git/inversoft/libraries/inversoft-scripts/src/main/ruby
export JAVA_HOME=/opt/fusionauth/apps/java/current17
eval "$(rbenv init - zsh)"
[[ -f "$HOME/.aws/aws.sh" ]] && source "$HOME/.aws/aws.sh"

alias devsetup="/Users/john/git/inversoft/fusionauth/fusionauth-developer/setup.sh"
