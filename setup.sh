#!/usr/bin/env bash
# shellcheck disable=1090,1091,2153

set -o errexit
set -o nounset
set -o pipefail

# Get the path this script lives in so it'll work if called from another directory.
MYDIR=$(cd -- "$(dirname "$0")" >/dev/null 2>&1; pwd -P)
cd "${MYDIR}"

# bootstrap.sh sources the other core scripts.
source "${MYDIR}/setup/core/bootstrap.sh"

function main() {
  argparse "$@"

  if [[ "${DEBUG}" = true ]]; then set -xv; fi

  # Make sure all modules in the list are valid.
  for module in "${MODULES[@]}"; do
    if file_missing "${MYDIR}/setup/modules/${module}.sh"; then
      fail "Module '${module}' does not exist."
    fi
  done

  # Run the modules.
  for module in "${MODULES[@]}"; do
    echo ""
    attn "Running ${module} setup..."
    source "${MYDIR}/setup/modules/${module}.sh"
    setup_"${module}"
  done

  # Create FLAGFILE if it doesn't exist.
  if file_missing "${FLAGFILE}"; then
    touch "${FLAGFILE}"
  fi

  success "\nDone!"
}


main "$@"
