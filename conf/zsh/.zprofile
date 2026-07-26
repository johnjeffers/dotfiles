#!/usr/bin/env zsh
# shellcheck disable=1090,1091

# Set up the shell for brew.
eval "$(/opt/homebrew/bin/brew shellenv)"

[ -f "${HOME}/.zprofile.local" ] && source "${HOME}/.zprofile.local"

# devsetup script
export PATH=/Users/john/dev/bin:$PATH
alias devsetup="/Volumes/git/inversoft/fusionauth-eng/fusionauth-developer/setup.sh"

# mise
eval "$(mise activate zsh)"
export PATH=/Users/john/.local/share/mise/shims:$PATH
