#!/usr/bin/env bash

function setup_ssh() {
  # Create the directory if it doesn't exist.
  local sshdir="${HOME}/.ssh"
  if dir_missing "${sshdir}"; then
    create_directory "${sshdir}"
  fi

  # Symlink the config file.
  local config="${sshdir}/config"
  if file_exists "${config}" && not_symlink "${config}"; then
    archive_file "${config}"
  fi
  if file_missing "${config}"; then
    create_softlink "${MYDIR}/conf/ssh/config" "${config}"
  fi

  success "Configured ssh"
}
