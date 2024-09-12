#!/usr/bin/env bash

function setup_zsh() {
  local zshrc="${HOME}/.zshrc"
  # If .zshrc already exists, back it up
  if file_exists "${zshrc}" && not_symlink "${zshrc}"; then
    archive_file "${zshrc}"
  fi
  # Add .zshrc symlink if it doesn't exist
  create_softlink "${MYDIR}/conf/zsh/.zshrc.${LOCALE}" "${zshrc}"

  local zprofile="${HOME}/.zprofile"
  # If .zprofile already exists, back it up
  if file_exists "${zprofile}" && not_symlink "${zprofile}"; then
    archive_file "${zprofile}"
  fi
  # Add .zprofile symlink if it doesn't exist
  create_softlink "${MYDIR}/conf/zsh/.zprofile.${LOCALE}" "${zprofile}"

  success "Configured zsh"
}
