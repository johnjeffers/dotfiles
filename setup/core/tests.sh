#!/usr/bin/env bash
# shellcheck disable=2034

# TODO - bats? some other test framework?

# Tests for the helper functions.
readonly cmd1="brew"
readonly cmd2="fake"
readonly dir1="/tmp"
readonly dir2="/fake"
readonly file1="$HOME/.DS_Store"
readonly file2="$HOME/fake"
readonly link1="$HOME/.zshrc"
readonly link2="$HOME/fake"
readonly var1="asdf"
readonly var2=""
echo -e "\nCommand Tests\n"
if command_exists  "${cmd1}";  then echo "${cmd1}: ${GREEN}cmd_exists true${RESET}";  else echo "${cmd1}: ${RED}cmd_exists false${RESET}"; fi
if command_missing "${cmd1}";  then echo "${cmd1}: ${RED}cmd_missing true${RESET}";   else echo "${cmd1}: ${GREEN}cmd_missing false${RESET}"; fi
if command_exists  "${cmd2}";  then echo "${cmd2}: ${RED}cmd_exists true${RESET}";    else echo "${cmd2}: ${GREEN}cmd_exists false${RESET}"; fi
if command_missing "${cmd2}";  then echo "${cmd2}: ${GREEN}cmd_missing true${RESET}"; else echo "${cmd2}: ${RED}cmd_missing false${RESET}"; fi
echo -e "\nDirectory Tests\n"
if dir_exists  "${dir1}";  then echo "${dir1}: ${GREEN}dir_exists true${RESET}";  else echo "${dir1}: ${RED}dir_exists false${RESET}"; fi
if dir_missing "${dir1}";  then echo "${dir1}: ${RED}dir_missing true${RESET}";   else echo "${dir1}: ${GREEN}dir_missing false${RESET}"; fi
if dir_exists  "${dir2}";  then echo "${dir2}: ${RED}dir_exists true${RESET}";    else echo "${dir2}: ${GREEN}dir_exists false${RESET}"; fi
if dir_missing "${dir2}";  then echo "${dir2}: ${GREEN}dir_missing true${RESET}"; else echo "${dir2}: ${RED}dir_missing false${RESET}"; fi
echo -e "\nFile Tests\n"
if file_exists  "${file1}"; then echo "${file1}: ${GREEN}file_exists true${RESET}";  else echo "${file1}: ${RED}file_exists false${RESET}"; fi
if file_missing "${file1}"; then echo "${file1}: ${RED}file_missing true${RESET}";   else echo "${file1}: ${GREEN}file_missing false${RESET}"; fi
if file_exists  "${file2}"; then echo "${file2}: ${RED}file_exists true${RESET}";    else echo "${file2}: ${GREEN}file_exists false${RESET}"; fi
if file_missing "${file2}"; then echo "${file2}: ${GREEN}file_missing true${RESET}"; else echo "${file2}: ${RED}file_missing false${RESET}"; fi
echo -e "\nSymlink Tests\n"
if is_symlink  "${link1}"; then echo "${link1}: ${GREEN}is_symlink true${RESET}";  else echo "${link1}: ${RED}is_symlink false${RESET}"; fi
if not_symlink "${link1}"; then echo "${link1}: ${RED}not_symlink true${RESET}";   else echo "${link1}: ${GREEN}not_symlink false${RESET}"; fi
if is_symlink  "${link2}"; then echo "${link2}: ${RED}is_symlink true${RESET}";    else echo "${link2}: ${GREEN}is_symlink false${RESET}"; fi
if not_symlink "${link2}"; then echo "${link2}: ${GREEN}not_symlink true${RESET}"; else echo "${link2}: ${RED}not_symlink false${RESET}"; fi

# Exit after running the tests.
exit 0
