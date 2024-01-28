#!/usr/bin/env zsh
# shellcheck disable=1091,2034,2148,2154

### brew shell completion -- must be called before oh-my-zsh
# https://docs.brew.sh/Shell-Completion
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

### oh-my-zsh - https://ohmyz.sh/
# Theme is disabled because of Starship
ZSH_THEME=""
ZSH_DISABLE_COMPFIX=true
export ZSH=$HOME/.oh-my-zsh
plugins=(docker git kubectl)
source "$ZSH/oh-my-zsh.sh"

### Starship - https://starship.rs
eval "$(starship init zsh)"

### zsh plugins
# zsh-autosuggestions - https://github.com/zsh-users/zsh-autosuggestions
source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
# zsh-syntax-highlighting - https://github.com/zsh-users/zsh-syntax-highlighting
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

### My sourced configs
my_dir="$(dirname "$(readlink -f .zshrc)")"
configs="${my_dir}/configs"
source "${configs}/paths.sh"
source "${configs}/aliases.sh"
source "${configs}/zsh-syntax-highlighting.sh"

# Leaving this around so I don't have to figure it out again.
# Parse all files in a directory.
# while IFS= read -r -d '' file; do
# 	echo "${file}"
# done < <(find "${configs}" -type f -print0)
