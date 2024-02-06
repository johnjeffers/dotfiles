#!/usr/bin/env bash
# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail

# Get the path this script lives in so it'll work if called from another directory.
my_dir=$(cd -- "$(dirname "$0")" >/dev/null 2>&1; pwd -P)
cd "${my_dir}"

help() {
    printf "usage: setup.sh [-huvd]\n\n"
    printf "    -h  show this help\n"
    printf "    -u  update user data\n"
    printf "    -v  enable verbose output\n"
    printf "    -d  enable debug output (set -xv)\n\n"
    printf "Run 'setup.sh -vd' for maximum verbosity.\n"
    exit
}

validate_prereqs() {
    # Make sure brew is installed.
    if command_missing brew; then
        error "\nCannot find brew!"
        info "https://brew.sh for install instructions.\n"
        exit 1
    fi

    # Make sure oh-my-zsh is installed.
    if dir_missing "${HOME}/.oh-my-zsh"; then
        error "\nCannot find oh-my-zsh!"
        info "https://ohmyz.sh for install instructions.\n"
        exit 1
    fi
}

# Create and populate the DB with example data.
create_db() {
    info "\nCreating database"
    sqlite3 "${db}" "
        CREATE TABLE userdata (
            id INTEGER,
            repo_dir TEXT,
            my_name TEXT,
            my_email TEXT,
            work_email TEXT,
            company TEXT,
            brew_base TEXT,
            brew_home TEXT,
            brew_music TEXT,
            brew_work TEXT,
            brew_java TEXT);"
    sqlite3 "${db}" "
        INSERT INTO userdata (id, repo_dir, my_name, my_email, work_email, company, brew_base, brew_home, brew_music, brew_work, brew_java)
        VALUES (1, 'git', 'My Name', 'my@email', 'work@email', 'company-name', 'N', 'N', 'N', 'N', 'N');"
}

# Load user data from the DB
load_data() {
    REPO_DIR="$(sqlite3 "${db}"   "SELECT repo_dir FROM userdata WHERE id = 1;")"
    MY_NAME="$(sqlite3 "${db}"    "SELECT my_name FROM userdata WHERE id = 1;")"
    MY_EMAIL="$(sqlite3 "${db}"   "SELECT my_email FROM userdata WHERE id = 1;")"
    WORK_EMAIL="$(sqlite3 "${db}" "SELECT work_email FROM userdata WHERE id = 1;")"
    COMPANY="$(sqlite3 "${db}"    "SELECT company FROM userdata WHERE id = 1;")"
    BREW_BASE="$(sqlite3 "${db}"  "SELECT brew_base FROM userdata WHERE id = 1;")"
    BREW_HOME="$(sqlite3 "${db}"  "SELECT brew_home FROM userdata WHERE id = 1;")"
    BREW_MUSIC="$(sqlite3 "${db}" "SELECT brew_music FROM userdata WHERE id = 1;")"
    BREW_WORK="$(sqlite3 "${db}"  "SELECT brew_work FROM userdata WHERE id = 1;")"
    BREW_JAVA="$(sqlite3 "${db}"  "SELECT brew_java FROM userdata WHERE id = 1;")"
}

# Prompt to update user data.
update_data() {
    printf "\nPress enter to keep the current values.\n"

    info "\nBase dir for your repos. Will be created in \$HOME if it doesn't exist."
    read -r -p "Repo Dir (${REPO_DIR}): " input
    REPO_DIR="${input:-$REPO_DIR}"

    info "\nYour name is used in the global .gitconfig"
    read -r -p "Name (${MY_NAME}): " input
    MY_NAME="${input:-$MY_NAME}"

    info "\nYour personal email used is in the global .gitconfig"
    read -r -p "Email (${MY_EMAIL}): " input
    MY_EMAIL="${input:-$MY_EMAIL}"

    info "\nYour work email is used in the .gitconfig for your work repos"
    read -r -p "Email (${WORK_EMAIL}): " input
    WORK_EMAIL="${input:-$WORK_EMAIL}"

    info "\nThe company name will be used to create a subdir under ~/${REPO_DIR}"
    read -r -p "Company Name (${COMPANY}): " input
    COMPANY=$(echo "${input:-$COMPANY}" | awk '{print tolower($0)}')

    info "\nDo you want to install the components in the base brewfile?"
    read -r -p "Install base brewfile (${BREW_BASE}): " input
    BREW_BASE=$(echo "${input:-$BREW_BASE}" | awk '{print toupper($0)}')

    info "\nDo you want to install the components in the home brewfile?"
    read -r -p "Install home brewfile (${BREW_HOME}): " input
    BREW_HOME=$(echo "${input:-$BREW_HOME}" | awk '{print toupper($0)}')

    info "\nDo you want to install the components in the music brewfile?"
    read -r -p "Install music brewfile (${BREW_MUSIC}): " input
    BREW_MUSIC=$(echo "${input:-$BREW_MUSIC}" | awk '{print toupper($0)}')

    info "\nDo you want to install the components in the work brewfile?"
    read -r -p "Install work brewfile (${BREW_WORK}): " input
    BREW_WORK=$(echo "${input:-$BREW_WORK}" | awk '{print toupper($0)}')

    info "\nDo you want to install the components in the java brewfile?"
    read -r -p "Install java brewfile (${BREW_JAVA}): " input
    BREW_JAVA=$(echo "${input:-$BREW_JAVA}" | awk '{print toupper($0)}')

    # Update the DB with the data we just collected.
    sqlite3 "${db}" "
        UPDATE userdata SET
            repo_dir =   '${REPO_DIR}',
            my_name =    '${MY_NAME}',
            my_email =   '${MY_EMAIL}',
            work_email = '${WORK_EMAIL}',
            company =    '${COMPANY}',
            brew_base =  '${BREW_BASE}',
            brew_home =  '${BREW_HOME}',
            brew_music = '${BREW_MUSIC}',
            brew_work =  '${BREW_WORK}',
            brew_java =  '${BREW_JAVA}'
        WHERE id = 1;"
}

show_data() {
    echo -e "\n${C_GRAY}We will use the following data:${C_RESET}\n"
    echo -e "${C_GRAY}Repo Dir:   ${C_YELLOW}${REPO_DIR}${C_RESET}"
    echo -e "${C_GRAY}Name:       ${C_YELLOW}${MY_NAME}${C_RESET}"
    echo -e "${C_GRAY}Email:      ${C_YELLOW}${MY_EMAIL}${C_RESET}"
    echo -e "${C_GRAY}Work Email: ${C_YELLOW}${WORK_EMAIL}${C_RESET}"
    echo -e "${C_GRAY}Company:    ${C_YELLOW}${COMPANY}${C_RESET}"
    echo -e "${C_GRAY}Install base brewfile:  ${C_YELLOW}${BREW_BASE}${C_RESET}"
    echo -e "${C_GRAY}Install home brewfile:  ${C_YELLOW}${BREW_HOME}${C_RESET}"
    echo -e "${C_GRAY}Install music brewfile: ${C_YELLOW}${BREW_MUSIC}${C_RESET}"
    echo -e "${C_GRAY}Install work brewfile:  ${C_YELLOW}${BREW_WORK}${C_RESET}"
    echo -e "${C_GRAY}Install java brewfile:  ${C_YELLOW}${BREW_JAVA}${C_RESET}\n"
    echo -e "${C_GRAY}If this looks wrong, run ${C_YELLOW}setup.sh -u${C_GRAY} to update.${C_RESET}"
}

do_bash_stuff() {
    local bashrc=${HOME}/.bashrc
    # Backup the existing .bashrc if necessary.
    if file_exists "${bashrc}" && not_symlink "${bashrc}"; then
        backup_file "${bashrc}"
    fi
    # Create symlink to our .bashrc file.
    if file_missing "${bashrc}"; then
        info "Creating symlink for ~/.bashrc"
        ln -s -f "${my_dir}/conf/bash/.bashrc" "${bashrc}"
    fi

    success "Configured bash"
}

do_zsh_stuff() {
    local zshrc=${HOME}/.zshrc
    # Backup the existing .zshrc if necessary.
    if file_exists "${zshrc}" && not_symlink "${zshrc}"; then
        backup_file "${zshrc}"
    fi
    # Create symlink to our .zshrc file.
    if file_missing "${zshrc}"; then
        info "Creating symlink for ~/.zshrc"
        ln -s -f "${my_dir}/conf/zsh/.zshrc" "${zshrc}"
    fi

    local zprofile=${HOME}/.zprofile
    # Backup the existing .zprofile if necessary.
    if file_exists "${zprofile}" && not_symlink "${zprofile}"; then
        backup_file "${zprofile}"
    fi
    # Create symlink to our .zprofile file.
    if file_missing "${zprofile}"; then
        info "Creating symlink for ~/.zprofile"
        ln -s -f "${my_dir}/conf/zsh/.zprofile" "${zprofile}"
    fi

    success "Configured zsh"
}

do_starship_stuff() {
    # Install fonts used by iTerm2/Starship.
    fonts="MonacoNerdFont-Regular.ttf MonacoNerdFontMono-Regular.ttf"
    for font in $fonts; do
        if file_missing "${HOME}/Library/Fonts/${font}"; then
            info "Installing font ${font}..."
            cp "${my_dir}/fonts/${font}" "${HOME}/Library/Fonts"
        fi
    done

    local cfg=${HOME}/.config/starship.toml
    # Backup the existing config if necessary.
    if file_exists "${cfg}" && not_symlink "${cfg}"; then
        backup_file "${cfg}"
    fi
    # Create symlink to our theme.
    if file_missing "${cfg}"; then
        info "Creating symlink for starship config"
        ln -s -f "${my_dir}/conf/starship/starship.toml" "${cfg}"
    fi

    success "Configured starship"
}

do_brew_stuff() {
    local v=""
    if [[ ${verbose} = true ]]; then
        v="--verbose";
    fi

    info "Installing minimal brewfile"
    brew bundle "${v}" --file "${my_dir}/brew/1-minimal.brewfile"
    if [[ "${BREW_BASE}" == 'Y' ]]; then
        info "\nInstalling base brewfile"
        brew bundle "${v}" --file "${my_dir}/brew/2-base.brewfile"
    fi
    if [[ "${BREW_HOME}" == 'Y' ]]; then
        info "\nInstalling home brewfile"
        brew bundle "${v}" --file "${my_dir}/brew/3-home.brewfile"
    fi
    if [[ "${BREW_MUSIC}" == 'Y' ]]; then
        info "\nInstalling music brewfile"
        brew bundle "${v}" --file "${my_dir}/brew/4-music.brewfile"
    fi
    if [[ "${BREW_WORK}" == 'Y' ]]; then
        info "\nInstalling work brewfile"
        brew bundle "${v}" --file "${my_dir}/brew/5-work.brewfile"
    fi
    if [[ "${BREW_JAVA}" == 'Y' ]]; then
        info "\nInstalling java brewfile"
        brew bundle "${v}" --file "${my_dir}/brew/6-java.brewfile"
    fi

    info "\nUpdating brew casks"
    brew cu --include-mas --cleanup
    success "Done updating brew casks"
    info "\nUpdating packages not in your Brewfiles..."
    brew upgrade
    success "Done updating packages"
    info "\nCleaning up..."
    brew autoremove
    brew cleanup
    success "Done cleaning up"
}

do_aws_stuff() {
    local awsdir=${HOME}/.aws
    # Create ~/.aws if it doesn't exist.
    if dir_missing "${awsdir}"; then
        info "Creating directory ${awsdir}"
        mkdir -p "${awsdir}"
    fi

    # Create hard link to our config.
    # Uses a hard link instead of a symlink so it can be used in a docker volume mount.
    local awscfg=${awsdir}/config
    if file_missing "${awscfg}"; then
        info "Creating hard link for ~/.aws/config"
        ln -f "${my_dir}/conf/aws/config" "${awscfg}"
    fi

    success "Configured awscli"
}

do_git_stuff() {
    local git_root=${HOME}/${REPO_DIR}

    # Create the git repo directories if they don't exist.
    local personal="${git_root}/personal"
    if dir_missing "${personal}"; then
        info "Creating ${personal}"
        mkdir -p "${personal}"
    fi
    local public="${git_root}/public"
    if dir_missing "${public}"; then
        info "Creating ${public}"
        mkdir -p "${public}"
    fi
    WORK_GIT="${git_root}/${COMPANY}"
    if dir_missing "${WORK_GIT}"; then
        info "Creating ${WORK_GIT}"
        mkdir -p "${WORK_GIT}"
    fi

    # Some vars need to be exported to work with envsubst.
    export MY_NAME MY_EMAIL WORK_EMAIL WORK_GIT
    envsubst < "${my_dir}/conf/git/.gitconfig.global" > "${HOME}/.gitconfig"
    envsubst < "${my_dir}/conf/git/.gitconfig.work" > "${WORK_GIT}/.gitconfig"

    success "Configured git"
}

do_iterm_stuff() {
    # Configure iTerm to use our preferences file.
    if dir_exists "/Applications/iTerm.app"; then
        defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$my_dir/conf/iterm"
        defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
        success "Configured iterm"
    else
        error "Cannot find iterm!"
    fi
}

do_python_stuff() {
    # Create a python3 venv
    if command_exists python3; then
        if dir_missing "${HOME}/venvs/python3"; then
            info "Creating python virtual env"
            mkdir -p "${HOME}/venvs/python3"
            python3 -m venv "${HOME}/venvs/python3"
        fi
        if dir_exists "${HOME}/venvs/python3"; then
            info "Updating python virtual env"
            source "${HOME}/venvs/python3/bin/activate"
            # I'm only installing public packages, so always use pypi.org for pip installs.
            # This overrides any local config that might be pointed at a private repo.
            if [[ "${verbose}" = true ]]; then
                pip install -U --index-url https://pypi.org/simple pip
                pip install -U --index-url https://pypi.org/simple -r "${my_dir}/conf/python/requirements.txt"
            else
                # Pipe pip to grep to suppress output if there are no updates.
                pip install -U --index-url https://pypi.org/simple pip | { grep -v 'Requirement already satisfied' || true; }
                pip install -U --index-url https://pypi.org/simple -r "${my_dir}/conf/python/requirements.txt" | { grep -v 'Requirement already satisfied' || true; }
            fi
            deactivate
        fi
        success "Configured python"
    else
        error "Cannot find python!"
    fi
}

main() {
    source "${my_dir}/scripts/helpers.sh"

    # Path to the sqlite database that stores user data.
    db="${my_dir}/dotfiles.db"
    # Preference args defaults.
    update=false   # update user data
    verbose=false  # verbosity
    debug=false    # set -xv

    # Parse arguments.
    while getopts huvd flag; do
        case "${flag}" in
            u) update=true;;
            v) verbose=true;;
            d) debug=true;;
            h|*) help;;
        esac
    done

    if [[ ${debug} = true ]]; then
        set -xv
    fi

    validate_prereqs

    # Create the database if necessary.
    if file_missing "${db}"; then
        create_db
        # If we have to create the database, prompt the user to update.
        update=true
    fi

    load_data
    if [[ "${update}" == true ]]; then
        update_data
    fi
    show_data

    # Configure shells
    echo ""
    do_bash_stuff
    do_zsh_stuff
    do_starship_stuff

    # Install apps
    echo ""
    do_brew_stuff
    # Configure apps
    echo ""
    do_aws_stuff
    do_git_stuff
    do_iterm_stuff
    do_python_stuff

    success "\nDone!"
}

main "$@"
