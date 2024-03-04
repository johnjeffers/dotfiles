#!/usr/bin/env bash
# shellcheck disable=1091

# TODO - remove the stuff that depends on bash 4 so we can eliminate this check
source "${MYDIR}/setup/core/globals.sh"

# We have to do this check before we source our helper functions,
# so we need to use regular echo with color codes here.
if ((BASH_VERSINFO[0] < 4)); then
    echo -e "${YELLOW}bash version ${BASH_VERSION} detected. You need bash version 4 or later.${RESET}\n"
    echo -e "${GRAY}Run ${RESET}brew install bash${GRAY} and try again.${RESET}"
    exit 1
fi

source "${MYDIR}/setup/core/helpers.sh"
source "${MYDIR}/setup/core/argparse.sh"

# This overrides some of the defaults in globals.sh
if file_exists "${MYDIR}/.env"; then
  source "${MYDIR}/.env"
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
  update_env_file "BREW_MUSIC"   "Install brewfile.music?"
  update_env_file "BREW_WORK"    "Install brewfile.work?"
fi
