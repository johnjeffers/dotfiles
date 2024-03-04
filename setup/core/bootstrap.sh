#!/usr/bin/env bash

# TODO - remove the stuff that depends on bash 4 so we can eliminate this check

# We have to do this check before we source our helper functions,
# so we need to use regular echo with color codes here.
if ((BASH_VERSINFO[0] < 4)); then
    echo -e "${YELLOW}bash version ${BASH_VERSION} detected. You need bash version 4 or later.${RESET}\n"
    echo -e "${GRAY}Run ${RESET}brew install bash${GRAY} and try again.${RESET}"
    exit 1
fi
