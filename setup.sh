#!/usr/bin/env bash
# shellcheck disable=1090,1091,2153

set -o errexit
set -o nounset
set -o pipefail

# Get the path this script lives in so it'll work if called from another directory.
MYDIR=$(cd -- "$(dirname "$0")" >/dev/null 2>&1; pwd -P)
cd "${MYDIR}"

function main() {
  source "${MYDIR}/scripts/globals.sh"
  source "${MYDIR}/scripts/bootstrap.sh"
  source "${MYDIR}/scripts/helpers.sh"
  source "${MYDIR}/scripts/argparse.sh"
  
  argparse "$@"

  if [[ "${DEBUG}" = true ]]; then set -xv; fi

  # Make sure the .env file exists
  if file_exists "${MYDIR}/.env"; then
    source "${MYDIR}/.env"
  else
    error "Missing .env file!\n"
    info "Run 'cp .env.template .env'"
    info "Edit .env to fill in your details and preferences."
    exit 1
  fi

  # Make sure all modules in the list are valid.
  for module in "${MODULES[@]}"; do
    if file_missing "${MYDIR}/modules/${module}.sh"; then
      fail "Module '${module}' does not exist."
    fi
  done

  # Run the modules.
  for module in "${MODULES[@]}"; do
    echo ""
    attn "Running ${module} setup..."
    source "${MYDIR}/modules/${module}.sh"
    setup_"${module}"
  done

  success "\nDone!"
}


main "$@"
