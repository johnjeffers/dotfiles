#!/usr/bin/env bash
# shellcheck disable=SC1091

# TODO - remove the stuff that depends on bash 4 so we can eliminate this check

# We have to do this check before we source our helper functions,
# so we need to use regular echo with color codes here.
if ((BASH_VERSINFO[0] < 4)); then
    echo -e "$(tput setaf 202)bash version ${BASH_VERSION} detected. You need bash version 4 or later.$(tput sgr0)\n"
    echo -e "$(tput setaf 248)Run $(tput sgr0)brew install bash$(tput sgr0) $(tput setaf 248)and try again.$(tput sgr0)"
    exit 1
fi

# TODO - handle installing brew and ohmyzsh

# if command_missing brew; then
#     error "\nCannot find brew!"
#     info "https://brew.sh for install instructions.\n"
#     exit 1
# fi

# # Make sure oh-my-zsh is installed.
# if dir_missing "${HOME}/.oh-my-zsh"; then
#     error "\nCannot find oh-my-zsh!"
#     info "https://ohmyz.sh for install instructions.\n"
#     exit 1
# fi
