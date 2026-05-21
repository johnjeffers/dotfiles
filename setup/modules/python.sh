#!/usr/bin/env bash

function setup_python() {
  if command_missing uv; then
    fail "Cannot find uv!"
  fi

  local toolfile="${MYDIR}/conf/python/tools.txt"
  local uv_flags=(--upgrade --default-index https://pypi.org/simple)

  if [[ "${VERBOSE}" != true ]]; then
    uv_flags+=(--no-progress)
  fi

  while IFS= read -r tool; do
    if [[ -z "${tool}" || "${tool}" == \#* ]]; then
      continue
    fi

    info "Installing Python tool ${tool}"
    uv tool install "${uv_flags[@]}" "${tool}"
  done < "${toolfile}"

  success "Configured python"
}
