#!/usr/bin/env bash

function setup_aws() {
  # Create ~/.aws if it doesn't exist.
  local awsdir="${HOME}/.aws"
  create_directory "${awsdir}"

  # Create hard link to our config.
  # (hard link instead of a symlink so it can be used in a docker volume mount.)
  local awscfg=${awsdir}/config
  create_hardlink "${MYDIR}/conf/aws/config" "${awscfg}"

  success "Configured awscli"
}
