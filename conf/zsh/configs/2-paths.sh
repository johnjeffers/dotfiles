#!/usr/bin/env zsh
# shellcheck disable=1071

### Path additions to support various things.

# Sublime Text
path+=("/Applications/Sublime Text.app/Contents/SharedSupport/bin")

# Go
export GOPATH=$HOME/go
path+=("$HOME/go/bin")

# Python
path+=("$HOME/venvs/python3/bin")

# Postgres
path+=("/opt/homebrew/opt/postgresql@15/bin")

# FusionAuth stuff
path+=("${HOME}/dev/java/current17/bin")
export JAVA_HOME="${HOME}/dev/java/current17"
path+=("${HOME}/dev/savant/current/bin")
path+=("${HOME}/dev/inversoft/libraries/inversoft-scripts/src/main/ruby")
eval "$(rbenv init - zsh)"
