#!/usr/bin/env zsh

### Path additions
# Sublime Text
path+=("/Applications/Sublime Text.app/Contents/SharedSupport/bin")
# Go
export GOPATH=$HOME/go
path+=("$HOME/go/bin")
# Python
path+=("$HOME/venvs/python3/bin")
path+=("/opt/homebrew/opt/postgresql@15/bin")
