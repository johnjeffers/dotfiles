#!/usr/bin/env bash

function setup_ohmyzsh() {
  if command_missing omz; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi
}
