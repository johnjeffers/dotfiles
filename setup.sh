#!/usr/bin/env bash
# shellcheck disable=1090,1091,2153

set -o errexit
set -o errtrace
set -o nounset
set -o pipefail

# Get the path this script lives in so it'll work if called from another directory.
MYDIR=$(cd -- "$(dirname "$0")" >/dev/null 2>&1; pwd -P)
cd "${MYDIR}"

# bootstrap.sh sources the other core scripts.
source "${MYDIR}/setup/core/bootstrap.sh"

function main() {
  argparse "$@"
  setup_env_file

  if [[ "${DEBUG}" = true ]]; then set -xv; fi

  # Report which module was running if we exit non-zero. errexit kills the
  # script silently otherwise, and .first_run won't be touched, so the next
  # invocation re-prompts for .env values with no hint at what blew up.
  current_module=""
  trap '[[ -n "${current_module}" ]] && error "\nFailed during ${current_module} setup"' ERR

  # Validate every module before running any: file must exist, source cleanly,
  # and define setup_<module>. Catches typos and missing/misnamed functions
  # before any module makes changes on disk.
  for module in "${MODULES[@]}"; do
    if file_missing "${MYDIR}/setup/modules/${module}.sh"; then
      fail "Module '${module}' does not exist."
    fi
    source "${MYDIR}/setup/modules/${module}.sh"
    if ! declare -F "setup_${module}" >/dev/null; then
      fail "Module '${module}' does not define setup_${module}()."
    fi
  done

  # Run the modules. Re-cd to MYDIR before each so a module that cd's
  # elsewhere doesn't leave the next one in the wrong directory.
  for module in "${MODULES[@]}"; do
    echo ""
    attn "Running ${module} setup..."
    cd "${MYDIR}"
    current_module="${module}"
    setup_"${module}"
  done
  current_module=""

  # Create FLAGFILE if it doesn't exist.
  if file_missing "${FLAGFILE}"; then
    touch "${FLAGFILE}"
  fi

  success "\nDone!"
}


main "$@"
