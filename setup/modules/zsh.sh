#!/usr/bin/env bash

function setup_zsh() {
  link_with_backup "${MYDIR}/conf/zsh/.zshrc"    "${HOME}/.zshrc"
  link_with_backup "${MYDIR}/conf/zsh/.zprofile" "${HOME}/.zprofile"

  # On work machines, layer the work-only overlay on top via the .local hook
  # in each base file.
  if [[ "${BREW_WORK}" == "true" ]]; then
    link_with_backup "${MYDIR}/conf/zsh/.zshrc.work"    "${HOME}/.zshrc.local"
    link_with_backup "${MYDIR}/conf/zsh/.zprofile.work" "${HOME}/.zprofile.local"
  fi

  success "Configured zsh"
}
