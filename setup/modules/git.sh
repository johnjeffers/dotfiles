#!/usr/bin/env bash

function setup_git() {
  # Create the git directories if they don't exist
  # Strips quotes in case ~ is being used instead of $HOME
  local dirs=(
    "${MY_REPOS}"
    "${PUBLIC_REPOS}"
    "${WORK_REPOS}"
  )
  for dir in "${dirs[@]}"; do
    create_directory "${dir}"
  done

  # Some vars need to be exported to work with envsubst.
  export MY_NAME MY_EMAIL WORK_REPOS WORK_NAME WORK_EMAIL PUBLIC_REPOS PUBLIC_NAME PUBLIC_EMAIL
  envsubst < "${MYDIR}/conf/git/.gitconfig.global" > "${HOME}/.gitconfig"
  envsubst < "${MYDIR}/conf/git/.gitconfig.public" > "${PUBLIC_REPOS}/.gitconfig"
  envsubst < "${MYDIR}/conf/git/.gitconfig.work" > "${WORK_REPOS}/.gitconfig"

  success "Configured git"
}
