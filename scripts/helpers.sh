#!/usr/bin/env bash
# shellcheck disable=1091,2154

# NOTE: Some of this stuff requires bash 4.2 or greater, which means
# it won't work with the bash that ships with MacOS. Install a newer
# bash with `brew install bash`.

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
