#!/usr/bin/env bash
# shellcheck disable=1090,1091

# Set up the shell for brew
eval "$(/opt/homebrew/bin/brew shellenv)"

[ -f "${HOME}/.bash_profile.local" ] && source "${HOME}/.bash_profile.local"

# rust
. "$HOME/.cargo/env"

# devsetup script
export PATH=/Users/john/dev/bin:$PATH
alias devsetup="/Volumes/git/inversoft/fusionauth-eng/fusionauth-developer/setup.sh"

# mise
eval "$(mise activate zsh)"
export PATH=/Users/john/.local/share/mise/shims:$PATH
