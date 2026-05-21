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

  local cfg="${HOME}/.config/starship.toml"
  link_with_backup "${MYDIR}/conf/starship/starship.toml" "${cfg}"

  success "Configured starship"
}
