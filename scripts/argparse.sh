#!/usr/bin/env bash
# shellcheck disable=2034

function show_help() {
  printf "\nusage: ./setup.sh [--all | --only module,module...]\n"
  printf "    -h --help       show this help\n"
  printf "    -a --all        run all of the modules\n"
  printf "    -o --only       run one or more modules (comma-separated list, no spaces)\n"
  printf "    -d --debug      enable debug output (set -xv)\n"
  printf "    -v --verbose    enable verbose output\n\n"
  printf "Use both --debug and --verbose for maximum verbosity.\n"
  exit
}


function argparse() {
  if [[ "$#" -eq 0 ]]; then
    error "\nAt least one argument is required."
    show_help
  fi
  
  local runarg=1  # Used to make sure mutually exclusive args are not passed.

  while (( "$#" )); do
    case "$1" in
      -a|--all)
        ((runarg++))
        shift;;
      -o|--only)
        ((runarg++))
        shift
        if (( $# < 1 )); then
          error "\n--only requires a comma-separated list of modules"
          show_help
        fi
        # Convert the CSV list to an array
        IFS=, read -r -a MODULES <<< "${1}"
        shift;;
      -d|--debug)   DEBUG=true; shift;;
      -v|--verbose) VERBOSE=true; shift;;
      -h|--help)    shift; show_help;;
      *)            error "\nUnsupported flag '${1}'"; show_help;;
    esac
  done

  if ((runarg < 2)); then
    error "\n--all or --only is required"
    show_help
  fi

  if ((runarg > 2)); then
    error "\nOnly one of --all or --only may be used"
    show_help
  fi 
}
