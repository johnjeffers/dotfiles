#!/usr/bin/env bash

function setup_ssh() {
  local sshdir="${HOME}/.ssh"
  if dir_missing "${sshdir}"; then
    create_directory "${sshdir}"
  fi

  link_with_backup "${MYDIR}/conf/ssh/config" "${sshdir}/config"

  # On work machines, the base ssh config picks up ~/.ssh/config.local* via
  # its Include directive.
  if [[ "${BREW_WORK}" == "true" ]]; then
    link_with_backup "${MYDIR}/conf/ssh/config.work" "${sshdir}/config.local"
  fi

  success "Configured ssh"
}
