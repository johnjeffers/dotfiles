#!/usr/bin/env bash

function setup_hosts() {
  # Skip this module if $FLAGFILE exists.
  if file_exists "${FLAGFILE}"; then
    info "This module only runs once. If you want to run it again:"
    echo "rm ${FLAGFILE}"
    return
  fi

  local newname=""

  read -r -p "Press enter to keep '$(hostname -s)', or enter a new name: " newname

  if [[ "${newname}" == "" ]]; then
    success "Keeping hostname '$(hostname -s)'"
  else
    sudo scutil --set ComputerName "${newname}"
    sudo scutil --set HostName "${newname}.local"
    sudo scutil --set LocalHostName "${newname}"
    success "Set hostname to ${newname}"
  fi
}
