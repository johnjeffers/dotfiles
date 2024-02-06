#!/usr/bin/env zsh
# shellcheck disable=1091,2034

### General zshrc stuff.
# !!! This file must be sourced first !!!

### brew shell completion -- must be called before oh-my-zsh
# https://docs.brew.sh/Shell-Completion
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

### oh-my-zsh - https://ohmyz.sh/
# Theme is disabled because I switched to Starship.
ZSH_THEME=""
ZSH_DISABLE_COMPFIX=true
export ZSH=$HOME/.oh-my-zsh
export ZSH_COMPDUMP=$HOME/.cache/.zcompdump
plugins=(docker git kubectl)
source "$ZSH/oh-my-zsh.sh"

### Starship - https://starship.rs
eval "$(starship init zsh)"

### zsh plugins
# zsh-autosuggestions - https://github.com/zsh-users/zsh-autosuggestions
source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
# zsh-syntax-highlighting - https://github.com/zsh-users/zsh-syntax-highlighting
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
