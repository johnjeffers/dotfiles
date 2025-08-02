#!/usr/bin/env bash

function setup_sublime() {
  if dir_missing "/Applications/Sublime Text.app" ]; then
    error "Sublime Text is not installed"
  fi

  SUBL_PATH="$HOME/Library/Application Support/Sublime Text"

  install_package_control
  install_packages
  configure_app_settings
  configure_package_settings

  success "Configured Sublime Text"
}


function install_package_control() {
  if file_missing "$SUBL_PATH/Installed Packages/Package Control.sublime-package"; then
    info "Installing Package Control"
    create_directory "$SUBL_PATH/Installed Packages/"
    curl -o "$SUBL_PATH/Installed Packages/Package Control.sublime-package" https://packagecontrol.io/Package%20Control.sublime-package
    success "Package Control installed successfully"
  fi
}


function install_packages() {
  info "Configuring Package Control"
  create_directory "$SUBL_PATH/Packages/User/"
  cat <<EOF > "$SUBL_PATH/Packages/User/Package Control.sublime-settings"
{
  "bootstrapped": true,
  "in_process_packages": [],
  "installed_packages": [
    "Dockerfile Syntax Highlighting",
    "Formatter",
    "Git",
    "MarkdownPreview",
    "Package Control",
    "Pretty JSON",
    "SideBarEnhancements",
    "SublimeLinter",
    "SublimeLinter-contrib-yamllint",
    "SublimeLinter-pylint",
    "SublimeLinter-shellcheck",
    "Terraform",
    "Terrafmt",
    "Terminal",
    "Theme - Monokai Pro",
  ],
}
EOF
}


function configure_app_settings() {
  info "Configuring settings"
  cat <<EOF > "$SUBL_PATH/Packages/User/Preferences.sublime-settings"
{
  "ignored_packages": [
    "Vintage",
  ],
  "index_files": true,

  // theme and appearance stuff
  "theme": "Monokai Pro.sublime-theme",
  "color_scheme": "Monokai Pro.sublime-color-scheme",
  "font_face": "Monaco Nerd Font",
  "font_size": 12,
  "font_options": ["no_clig", "no_liga", "no_calt"],
  "monokai_pro_style_title_bar": true,
  "monokai_pro_sidebar_row_padding": 1,
  "monokai_pro_panel_font_size": 12,

  // whitespace and newline stuff
  "trim_trailing_white_space_on_save": "all",
  "ensure_newline_at_eof_on_save": true,
}
EOF
}


function configure_package_settings() {
  info "Configuring packages"

  # Monokai Pro
  info "- Monokai Pro"
  if file_missing "$SUBL_PATH/Packages/User/Theme - Monokai Pro.sublime-settings"; then
    echo "Configuring Monokai Pro Theme"
    read -r -p "Monokai Pro license email: " monokai_license_email
    read -r -p "Monokai Pro license key: " monokai_license_key
    cat <<EOF > "$SUBL_PATH/Packages/User/Theme - Monokai Pro.sublime-settings"
{
  "email": "$monokai_license_email",
  "license_key": "$monokai_license_key",
}
EOF
  fi

  # SublimeLinter
  info "- SublimeLinter"
  cat <<EOF > "$SUBL_PATH/Packages/User/SublimeLinter.sublime-settings"
{
  "paths": {
    "osx": [
      "/Users/john/venvs/python3/bin/",
    ]
  },
  "linters": {
    "shellcheck": {
      "args": [
        "--shell=bash",
      ]
    },
  },
}
EOF

  # Terminal
  info "- Terminal"
  cat <<EOF > "$SUBL_PATH/Packages/User/Terminal.sublime-settings"
{
  "terminal": "iTerm2-v3.sh",
}
EOF
}
