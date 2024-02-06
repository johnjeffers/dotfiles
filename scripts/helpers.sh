#!/usr/bin/env bash
# shellcheck disable=1091,2154

# NOTE: Some of this stuff requires bash 4.2 or greater, which means
# it won't work with the bash that ships with MacOS. Install a newer
# bash with `brew install bash`.

# Set some colors
C_GRAY=$(tput setaf 248)
C_GREEN=$(tput setaf 2)
C_RED=$(tput setaf 202)
C_RESET=$(tput sgr0)
C_YELLOW=$(tput setaf 228)
export C_GRAY C_GREEN C_RED C_RESET C_YELLOW

# Logging functions
error()   { echo -e "${C_RED}${1}${C_RESET}" >&2; }
success() { echo -e "${C_GREEN}${1}${C_RESET}"; }
info()    { echo -e "${C_GRAY}${1}${C_RESET}"; }

# Backup a file, use timestamp as extension
backup_file() { mv "${1}" "${1}.$(date '+%Y%m%d%H%M%S')"; }

# Simple "does x exist/is x equal to" functions to use in boolean checks.
command_exists()  { if   command -v "${1}" &> /dev/null; then return 0; else return 1; fi } 
command_missing() { if ! command -v "${1}" &> /dev/null; then return 0; else return 1; fi } 
dir_exists()   { if   [[ -d "${1}" ]];  then return 0; else return 1; fi }
dir_missing()  { if ! [[ -d "${1}" ]];  then return 0; else return 1; fi }
file_exists()  { if   [[ -f "${1}" ]];  then return 0; else return 1; fi }
file_missing() { if ! [[ -f "${1}" ]];  then return 0; else return 1; fi }
is_symlink()   { if   [[ -L "${1}" ]];  then return 0; else return 1; fi }
not_symlink()  { if ! [[ -L "${1}" ]];  then return 0; else return 1; fi }
# Make sure we're on bash 4 or later.
if [ "${BASH_VERSINFO:-0}" -ge 4 ]; then
	var_set()      { if   [[ -v "${1}" ]];  then return 0; else return 1; fi }
	var_unset()    { if ! [[ -v "${1}" ]];  then return 0; else return 1; fi }
	var_empty()    { if   [[ -z "${!1}" ]]; then return 0; else return 1; fi }
else
	error "You need bash version 4 or later.\n"
	info "'brew install bash' and try again."
	exit 1
fi

# Tests for the functions above. If you uncomment this, it will run the tests and exit.
# source "${my_dir}/scripts/tests.sh"
