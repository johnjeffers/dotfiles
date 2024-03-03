#!/usr/bin/env bash

function setup_bash() {
  local bashrc="${HOME}/.bashrc"
  # If .bashrc already exists, back it up
  if file_exists "${bashrc}" && not_symlink "${bashrc}"; then
    archive_file "${bashrc}"
  fi
  # Add .bashrc symlink if it doesn't exist
  create_softlink "${MYDIR}/conf/bash/.bashrc" "${bashrc}"

  local bashprf="${HOME}/.bash_profile"
  # If .bash_profile already exists, back it up
  if file_exists "${bashprf}" && not_symlink "${bashprf}"; then
    archive_file "${bashprf}"
  fi
  # Add .bash_profile symlink if it doesn't exist
  create_softlink "${MYDIR}/conf/bash/.bash_profile" "${bashprf}"

  success "Configured bash"
}
