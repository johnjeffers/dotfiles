#!/usr/bin/env bash
# shellcheck disable=1091

setup_brew() {
  # Install brew if it's not already installed.
  if command_missing brew; then
    install_brew
  fi

  set_brew_vars
  source "${MYDIR}/.env"
  
  install_brewfiles

  info "\nUpdating brew casks"
  brew cu --include-mas --cleanup
  success "Done updating brew casks"

  info "\nUpdating packages not in your Brewfiles..."
  brew upgrade
  success "Done updating packages"

  info "\nRunning brew autoremove..."
  brew autoremove

  info "Running brew cleanup..."
  brew cleanup

  success "Done with brew tasks\n"
}


function install_brew() {
  info "Installing brew"
  if ! /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
    fail "Unable to install brew"
  fi
  success "brew installed successfully"

  # Set up the shell init files and reload so brew is available for next steps.
  shell_init profile "eval \"\$(${BREWDIR}/bin/brew shellenv)\""
  reload_shell
}


function set_brew_vars() {
  local value=false
  local varname=""
  
  # Loop thru the brewfiles.
  brewfiles=("base" "home" "music" "work")
  for brewfile in "${brewfiles[@]}"; do
    # Generate the var name.
    varname="$(echo "BREW_$brewfile" | tr '[:lower:]' '[:upper:]')"

    # Check if the var exists.
    if declare -p "${varname}" &>/dev/null; then
      # If FLAGFILE is missing, then prompt for all the responses.
      if file_missing "${FLAGFILE}"; then
        # If the var exits, check to see if it's set to true.
        case "${!varname}" in
          true)
            # If the var is set to true, make that the default response.
            read -r -p "${RESET}Install ${brewfile}.brewfile (yes) (${YELLOW}Y${RESET}/n) " value
            case ${value} in y|Y|"") value=true;;  *) value=false;; esac;;
          *)
            # If the var is set to aything else, make false the default response.
            read -r -p "${RESET}Install ${brewfile}.brewfile (no) (y/${YELLOW}N${RESET}) " value
            case ${value} in n|N|"") value=false;; *) value=true;; esac;;
        esac
        set_env "${varname}" "${value}"
      fi
    else
      # If the var does not exist, make false the default response.
      read -r -p "${RESET}Install ${brewfile}.brewfile (unset) (y/${YELLOW}N${RESET}) " value
      case ${value} in n|N|"") value=false;; *) value=true;; esac
      set_env "${varname}" "${value}"
    fi
  done
}


function install_brewfiles() {
  local v=""      # verbosity
  local varname=""  # check to see if we want to apply the brewfile

  # Set the --verbose flag if VERBOSE=true
  if [[ "${VERBOSE}" = true ]]; then v="--verbose"; fi

  # Always install the minimal.brewfile
  info "\nInstalling minimal brewfile"
  brew bundle "${v}" --file "${MYDIR}/brew/minimal.brewfile"

  # Loop through the remaining brewfiles.
  brewfiles=("base" "home" "music" "work")
  for brewfile in "${brewfiles[@]}"; do
    # Install the brewfile only if BREW_[brewfile] is set
    varname="$(echo "BREW_$brewfile" | tr '[:lower:]' '[:upper:]')"
    if [[ "${!varname}" == true ]]; then
      info "\nInstalling ${brewfile} brewfile"
      brew bundle "${v}" --file "${MYDIR}/brew/${brewfile}.brewfile"
  fi
  done
}
