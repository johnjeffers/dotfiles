#!/usr/bin/env zsh

# Set up the shell for brew.
eval "$(/opt/homebrew/bin/brew shellenv)"

# Added by fusionauth-developer setup script
if [[ -d ""$HOME/.pyenv"" ]]; then
  export PYENV_ROOT="$HOME/.pyenv"
  [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi
