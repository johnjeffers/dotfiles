#!/usr/bin/env bash
# shellcheck disable=1091

source "${MYDIR}/setup/core/globals.sh"
source "${MYDIR}/setup/core/helpers.sh"
source "${MYDIR}/setup/core/argparse.sh"

# This overrides some of the defaults in globals.sh
if file_exists "${MYDIR}/.env"; then
  source "${MYDIR}/.env"
fi

# Set locale
if [[ "${BREW_WORK}" == "true" ]]; then
  LOCALE="work"
fi

# If FLAGFILE or .env is missing, then ask to (re)set all the env vars
if file_missing "${FLAGFILE}" || file_missing "$MYDIR/.env"; then
  update_env_file "MY_NAME"      "Your full name for global gitconfig"
  update_env_file "MY_EMAIL"     "Your email addr for global gitconfig"
  update_env_file "MY_REPOS"     "Location of personal repos"
  update_env_file "PUBLIC_NAME"  "Your full name for public gitconfig"
  update_env_file "PUBLIC_EMAIL" "Your email addr for public gitconfig"
  update_env_file "PUBLIC_REPOS" "Location of public repos"
  update_env_file "WORK_NAME"    "Your full name for work gitconfig"
  update_env_file "WORK_EMAIL"   "Your email addr for work gitconfig"
  update_env_file "WORK_REPOS"   "Location of work repos"
  update_env_file "BREW_BASE"    "Install brewfile.base?"
  update_env_file "BREW_HOME"    "Install brewfile.home?"
  update_env_file "BREW_WORK"    "Install brewfile.work?"
fi
