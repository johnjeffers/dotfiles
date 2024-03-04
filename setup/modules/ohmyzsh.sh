#!/usr/bin/env bash

function setup_ohmyzsh() {
  if dir_missing "${HOME}/.oh-my-zsh"; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended >/dev/null
  fi

  success "Configured oh-my-zsh"
}
