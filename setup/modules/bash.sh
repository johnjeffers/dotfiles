#!/usr/bin/env bash

function setup_bash() {
  link_with_backup "${MYDIR}/conf/bash/.bashrc"       "${HOME}/.bashrc"
  link_with_backup "${MYDIR}/conf/bash/.bash_profile" "${HOME}/.bash_profile"

  # On work machines, layer the work-only overlay on top via the .local hook
  # in each base file.
  if [[ "${BREW_WORK}" == "true" ]]; then
    link_with_backup "${MYDIR}/conf/bash/.bashrc.work"       "${HOME}/.bashrc.local"
    link_with_backup "${MYDIR}/conf/bash/.bash_profile.work" "${HOME}/.bash_profile.local"
  fi

  success "Configured bash"
}
