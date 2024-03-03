#!/usr/bin/env zsh
# shellcheck disable=1090,1091

# Get the target path of the .zshrc symlink.
MYDIR="$(dirname "$(readlink -f "${HOME}/.zshrc")")"

# Source the configs.
for f in "${MYDIR}"/configs/*.sh; do source "${f}"; done

# Source the functions.
for f in "${MYDIR}"/functions/*.sh; do source "${f}"; done

# Added by fusionauth-developer setup script
#
# Make sure these values are in the script's .env file
# so it doesn't write new values.
#
# REPODIR="${HOME}/git/inversoft"
# INSTDIR="/opt/fusionauth/apps"
# BINDIR="/opt/fusionauth/bin"
if [[ -d "/opt/fusionauth" ]]; then
  export PATH=$PATH:/opt/fusionauth/bin
  export PATH=$PATH:/Users/john/git/inversoft/libraries/inversoft-scripts/src/main/ruby
  export JAVA_HOME=/opt/fusionauth/apps/java/current17
  alias devsetup="/Users/john/git/inversoft/fusionauth/fusionauth-developer/setup.sh"
  eval "$(rbenv init - zsh)"
fi
