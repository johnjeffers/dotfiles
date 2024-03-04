#!/usr/bin/env bash
# shellcheck disable=SC1091

function setup_python() {
  # Create a python3 venv
  if command_exists python3; then
    if dir_missing "${HOME}/venvs/python3"; then
      create_directory "${HOME}/venvs/python3"
      python3 -m venv "${HOME}/venvs/python3"
    fi
    if dir_exists "${HOME}/venvs/python3"; then
      source "${HOME}/venvs/python3/bin/activate"
      # I'm only installing public packages, so always use pypi.org for pip installs.
      # This overrides any local config that might be pointed at a private repo.
      if [[ "${VERBOSE}" = true ]]; then
        pip install -U --index-url https://pypi.org/simple pip
        pip install -U --index-url https://pypi.org/simple -r "${MYDIR}/conf/python/requirements.txt"
      else
        # Pipe pip to grep to suppress output if there are no updates.
        pip install -U --index-url https://pypi.org/simple pip | { grep -v 'Requirement already satisfied' || true; }
        pip install -U --index-url https://pypi.org/simple -r "${MYDIR}/conf/python/requirements.txt" | { grep -v 'Requirement already satisfied' || true; }
      fi
      deactivate
    fi
    success "Configured python"
  else
    error "Cannot find python!"
  fi
}
