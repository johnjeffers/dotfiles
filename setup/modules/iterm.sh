#!/usr/bin/env bash

function setup_iterm() {
  # Configure iTerm to use our preferences file.
  if dir_exists "/Applications/iTerm.app"; then
    defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$MYDIR/conf/iterm"
    defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
    success "Configured iterm"
  else
    error "Cannot find iterm!"
  fi
}
