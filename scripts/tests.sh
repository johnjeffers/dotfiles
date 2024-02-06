#!/usr/bin/env bash
# shellcheck disable=2034

# Tests for the helper functions.
cmd1="brew"
cmd2="fake"
dir1="/tmp"
dir2="/fake"
file1="$HOME/.DS_Store"
file2="$HOME/fake"
link1="$HOME/.zshrc"
link2="$HOME/fake"
var1="asdf"
var2=""
echo -e "\nCommand Tests\n"
if command_exists  "${cmd1}";  then echo "${cmd1}: ${C_GREEN}cmd_exists true${C_RESET}";  else echo "${cmd1}: ${C_RED}cmd_exists false${C_RESET}"; fi
if command_missing "${cmd1}";  then echo "${cmd1}: ${C_RED}cmd_missing true${C_RESET}";   else echo "${cmd1}: ${C_GREEN}cmd_missing false${C_RESET}"; fi
if command_exists  "${cmd2}";  then echo "${cmd2}: ${C_RED}cmd_exists true${C_RESET}";    else echo "${cmd2}: ${C_GREEN}cmd_exists false${C_RESET}"; fi
if command_missing "${cmd2}";  then echo "${cmd2}: ${C_GREEN}cmd_missing true${C_RESET}"; else echo "${cmd2}: ${C_RED}cmd_missing false${C_RESET}"; fi
echo -e "\nDirectory Tests\n"
if dir_exists  "${dir1}";  then echo "${dir1}: ${C_GREEN}dir_exists true${C_RESET}";  else echo "${dir1}: ${C_RED}dir_exists false${C_RESET}"; fi
if dir_missing "${dir1}";  then echo "${dir1}: ${C_RED}dir_missing true${C_RESET}";   else echo "${dir1}: ${C_GREEN}dir_missing false${C_RESET}"; fi
if dir_exists  "${dir2}";  then echo "${dir2}: ${C_RED}dir_exists true${C_RESET}";    else echo "${dir2}: ${C_GREEN}dir_exists false${C_RESET}"; fi
if dir_missing "${dir2}";  then echo "${dir2}: ${C_GREEN}dir_missing true${C_RESET}"; else echo "${dir2}: ${C_RED}dir_missing false${C_RESET}"; fi
echo -e "\nFile Tests\n"
if file_exists  "${file1}"; then echo "${file1}: ${C_GREEN}file_exists true${C_RESET}";  else echo "${file1}: ${C_RED}file_exists false${C_RESET}"; fi
if file_missing "${file1}"; then echo "${file1}: ${C_RED}file_missing true${C_RESET}";   else echo "${file1}: ${C_GREEN}file_missing false${C_RESET}"; fi
if file_exists  "${file2}"; then echo "${file2}: ${C_RED}file_exists true${C_RESET}";    else echo "${file2}: ${C_GREEN}file_exists false${C_RESET}"; fi
if file_missing "${file2}"; then echo "${file2}: ${C_GREEN}file_missing true${C_RESET}"; else echo "${file2}: ${C_RED}file_missing false${C_RESET}"; fi
echo -e "\nSymlink Tests\n"
if is_symlink  "${link1}"; then echo "${link1}: ${C_GREEN}is_symlink true${C_RESET}";  else echo "${link1}: ${C_RED}is_symlink false${C_RESET}"; fi
if not_symlink "${link1}"; then echo "${link1}: ${C_RED}not_symlink true${C_RESET}";   else echo "${link1}: ${C_GREEN}not_symlink false${C_RESET}"; fi
if is_symlink  "${link2}"; then echo "${link2}: ${C_RED}is_symlink true${C_RESET}";    else echo "${link2}: ${C_GREEN}is_symlink false${C_RESET}"; fi
if not_symlink "${link2}"; then echo "${link2}: ${C_GREEN}not_symlink true${C_RESET}"; else echo "${link2}: ${C_RED}not_symlink false${C_RESET}"; fi
echo -e "\nVariable Tests\n"
if var_set   var1; then echo "var1 = ${var1}: ${C_GREEN}var_set true${C_RESET}";   else echo "var1 = ${var1}: ${C_RED}var_set false${C_RESET}"; fi
if var_unset var1; then echo "var1 = ${var1}: ${C_RED}var_unset true${C_RESET}";   else echo "var1 = ${var1}: ${C_GREEN}var_unset false${C_RESET}"; fi
if var_empty var1; then echo "var1 = ${var1}: ${C_RED}var_empty true${C_RESET}";   else echo "var1 = ${var1}: ${C_GREEN}var_empty false${C_RESET}"; fi
if var_set   var2; then echo "var2: ${C_GREEN}var_set true${C_RESET}";             else echo "var2: ${C_RED}var_set false${C_RESET}"; fi
if var_unset var2; then echo "var2: ${C_RED}var_unset true${C_RESET}";             else echo "var2: ${C_GREEN}var_unset false${C_RESET}"; fi
if var_empty var2; then echo "var2: ${C_GREEN}var_empty true${C_RESET}";           else echo "var2: ${C_RED}var_empty false${C_RESET}"; fi
if var_set   var3; then echo "var3: ${C_RED}var_set true${C_RESET}";               else echo "var3: ${C_GREEN}var_set false${C_RESET}"; fi
if var_unset var3; then echo "var3: ${C_GREEN}var_unset true${C_RESET}";           else echo "var3: ${C_RED}var_unset false${C_RESET}"; fi

# Exit after running the tests.
exit 0
