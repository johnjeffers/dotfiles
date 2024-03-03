#!/usr/bin/env bash

setup_brew() {
  # Install brew if it's not already installed.
  if command_missing brew; then
    install_brew
  fi

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


function install_brewfiles() {
  local v=""      # verbosity
  local check=""  # check to see if we want to apply the brewfile

  # Set the --verbose flag if VERBOSE=true
  if [[ "${VERBOSE}" = true ]]; then v="--verbose"; fi

  # Always install the minimal.brewfile
  info "\nInstalling minimal brewfile"
  brew bundle "${v}" --file "${MYDIR}/brew/minimal.brewfile"

  # Loop through the remaining brewfiles.
  brewfiles=("base" "home" "music" "work")

  for brewfile in "${brewfiles[@]}"; do
    # Install the brewfile only if BREW_[brewfile] is set
    check="$(echo "BREW_$brewfile" | tr '[:upper:]' '[:lower:]')"
    if [[ "${check}" == true ]]; then
      info "\nInstalling ${brewfile} brewfile"
      brew bundle "${v}" --file "${MYDIR}/brew/${brewfile}.brewfile"
  fi
  done
}
