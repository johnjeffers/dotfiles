#!/usr/bin/env bash

function setup_starship() {
  # Install fonts used by iTerm2/Starship.
  fonts="MonacoNerdFont-Regular.ttf MonacoNerdFontMono-Regular.ttf"
  for font in $fonts; do
    if file_missing "${HOME}/Library/Fonts/${font}"; then
      info "Installing font ${font}..."
      cp "${MYDIR}/fonts/${font}" "${HOME}/Library/Fonts"
    fi
  done

  # Create ~/.config if it doesn't exist.
  create_directory "${HOME}/.config"

  local cfg=${HOME}/.config/starship.toml
  # Backup the existing config if necessary.
  if file_exists "${cfg}" && not_symlink "${cfg}"; then
    archive_file "${cfg}"
  fi

  # Create symlink to our theme.
  if file_missing "${cfg}"; then
    create_softlink "${MYDIR}/conf/starship/starship.toml" "${cfg}"
  fi

  success "Configured starship"
}
