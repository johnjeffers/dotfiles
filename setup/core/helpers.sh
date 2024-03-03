#!/usr/bin/env bash
# shellcheck disable=1091,2154

# NOTE: Some of this stuff requires bash 4.2 or greater, which means
# it won't work with the bash that ships with MacOS. Install a newer
# bash with `brew install bash`.

# Simple "does x exist/is x equal to" functions to use in boolean checks.
function command_exists()  { if   command -v "${1}" &> /dev/null; then return 0; else return 1; fi } 
function command_missing() { if ! command -v "${1}" &> /dev/null; then return 0; else return 1; fi } 
function dir_exists()      { if   [[ -d "${1}" ]];  then return 0; else return 1; fi }
function dir_missing()     { if ! [[ -d "${1}" ]];  then return 0; else return 1; fi }
function file_exists()     { if   [[ -f "${1}" ]];  then return 0; else return 1; fi }
function file_missing()    { if ! [[ -f "${1}" ]];  then return 0; else return 1; fi }
function is_symlink()      { if   [[ -L "${1}" ]];  then return 0; else return 1; fi }
function not_symlink()     { if ! [[ -L "${1}" ]];  then return 0; else return 1; fi }
function var_set()         { if   [[ -v "${1}" ]];  then return 0; else return 1; fi }
function var_unset()       { if ! [[ -v "${1}" ]];  then return 0; else return 1; fi }
function var_empty()       { if   [[ -z "${!1}" ]]; then return 0; else return 1; fi }
# Tests for the functions above. If you uncomment this, it will run the tests and exit.
# source "${MYDIR}/scripts/tests.sh"


# Output functions
function info()    { echo -e "${GRAY}${1}${RESET}"; }
function attn()    { echo -e "${YELLOW}${1}${RESET}"; }
function success() { echo -e "${GREEN}${1}${RESET}"; }
function error()   { echo -e "${RED}${1}${RESET}" >&2; }
function fail()    { echo -e "${RED}${1}${RESET}" >&2; exit 1; }
# Verbose output functions
function v_info()  { if [[ "${VERBOSE}" == true ]]; then echo -e "${GRAY}${1}${RESET}"; fi; }


# Archive a file, use timestamp as extension
function archive_file() {
  archive="${1}.$(date '+%Y%m%d%H%M%S')"
  info "Creating archive of ${1} to ${archive}"
  mv "${1}" "${archive}"
}


# Create directory if it doesn't already exist.
function create_directory() {
  v_info "Checking if directory ${RESET}${1}${GRAY} exists..."
  if dir_missing "${1}"; then
    info "Creating ${RESET}${1}${GRAY}"
    mkdir -p "${1}"
  else
    v_info "Directory ${RESET}${1}${GRAY} already exists"
  fi
}


# Create symlink if it doesn't already exist.
function create_softlink() {
  v_info "Checking if symlink ${RESET}${2}${GRAY} exists..."
  if file_missing "${2}"; then
    info "Soft linking ${RESET}${2} -> ${1}${GRAY}"
    ln -s -f "${1}" "${2}"
  else
    v_info "Symlink ${RESET}${2}${GRAY} already exists"
  fi
}


# Create hardlink if it doesn't already exist.
function create_hardlink() {
  v_info "Checking if hardlink ${RESET}${2}${GRAY} exists..."
  if file_missing "${2}"; then
    info "Hard linking ${RESET}${2} -> ${1}${GRAY}"
    ln -f "${1}" "${2}"
  else
    v_info "Hardlink ${RESET}${2}${GRAY} already exists"
  fi
}


# Add a init_cmd to bash and $SH_NAME init files if it doesn't already exist.
#
# Usage:
#   shell_init [initrc|profile] [init_cmd to add]
function shell_init() {
  local init_type="${1}"
  local init_cmd="${2}"
  local contents

  # Are we handling init (rc) or profile (pr)?
  local bashfile=""
  local shellfile=""
  case "${init_type}" in
    initrc)
      bashfile="${HOME}/.bashrc"
      shellfile="${SH_INITRC}";;
    profile)
      bashfile="${HOME}/.bash_profile"
      shellfile="${SH_PROFILE}";;
    *) fail "Invalid init file init_type [rc|pr]";;
  esac

  contents="
# Added by dotfiles setup script
${init_cmd}"

  if ! grep "${init_cmd}" "${shellfile}" >/dev/null 2>&1; then
    touch "${shellfile}"  # Create the file if it doesn't exist.
    echo -e "${contents}" >> "${shellfile}"
    info "Added init_cmd to ${shellfile}"
    info "${RESET}${init_cmd}"
  fi
  # If the user's default shell isn't bash, then also write the init_cmd to the equivalent bash file.
  if [[ "${SH_NAME}" != "bash" ]]; then
    if ! grep "${init_cmd}" "${bashfile}" >/dev/null 2>&1; then
      touch "${bashfile}" # Create the file if it doesn't exist
      echo -e "${contents}" >> "${bashfile}"
      info "Added init_cmd to ${bashfile}"
      info "${RESET}${init_cmd}"
    fi
  fi
}


# Source the init files during the script run.
function reload_shell() {
  set +o nounset
  export PS1="dummyvalue"
  if file_exists "${HOME}/.bash_profile"; then source "${HOME}/.bash_profile"; fi
  if file_exists "${HOME}/.bashrc";       then source "${HOME}/.bashrc"; fi
  unset PS1
  set -o nounset
}


# Set an env var in the .env file
# Usage:
#   set_env [varname] [value]
function set_env() {
  local varname="${1}"
  local value="${2}"
  local envfile="${MYDIR}/.env"

  if file_missing "${envfile}"; then
    info "Creating ${envfile}"
    touch "${envfile}"
  fi

  # If the var exists, but the value is different, update it
  if grep -w "${varname}" "${envfile}" >/dev/null; then
    if grep -w "${varname}=${value}" "${envfile}" >/dev/null; then
      v_info "${RESET}${varname}=${value}${GRAY} already set in .env"
      return
    else
      echo "Updating ${RESET}${varname}=${value}${GRAY} in .env"
      sed -i~ "/^${varname}=/s/=.*/=${value}/" "${envfile}"
    fi
  # If the var doesn't exist, create it.
  else
    info "Setting ${RESET}${varname}=${value}${GRAY} in .env"
    echo "${varname}=${value}" >> "${envfile}"
  fi
}
