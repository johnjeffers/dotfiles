#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

# Get the path this script lives in so it'll work if called from another directory.
my_dir=$(cd -- "$(dirname "$0")" >/dev/null 2>&1; pwd -P)
cd "${my_dir}"

help() {
    printf "usage: setup.sh [-huv]\n\n"
    printf "    -h  show this help\n"
    printf "    -u  update user data\n"
    printf "    -v  verbose output\n"
    exit
}

validate_prereqs() {
    # Make sure brew is installed.
    if ! brew --version &> /dev/null; then
        error "\nCannot find brew!"
        info "https://brew.sh for install instructions.\n"
        exit 1
    fi

    # Make sure oh-my-zsh is installed.
    if ! dir_exists "${HOME}/.oh-my-zsh"; then
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
            brew_home TEXT,
            brew_music TEXT,
            brew_work TEXT,
            brew_java TEXT);"
    sqlite3 "${db}" "
        INSERT INTO userdata (id, repo_dir, my_name, my_email, work_email, company, brew_home, brew_music, brew_work, brew_java)
        VALUES (1, 'git', 'My Name', 'my@email', 'work@email', 'company-name', 'N', 'N', 'N', 'N');"
}

# Load user data from the DB
load_data() {
    REPO_DIR="$(sqlite3 "${db}"   "SELECT repo_dir FROM userdata WHERE id = 1;")"
    MY_NAME="$(sqlite3 "${db}"    "SELECT my_name FROM userdata WHERE id = 1;")"
    MY_EMAIL="$(sqlite3 "${db}"   "SELECT my_email FROM userdata WHERE id = 1;")"
    WORK_EMAIL="$(sqlite3 "${db}" "SELECT work_email FROM userdata WHERE id = 1;")"
    COMPANY="$(sqlite3 "${db}"    "SELECT company FROM userdata WHERE id = 1;")"
    BREW_HOME="$(sqlite3 "${db}"  "SELECT brew_home FROM userdata WHERE id = 1;")"
    BREW_MUSIC="$(sqlite3 "${db}"  "SELECT brew_music FROM userdata WHERE id = 1;")"
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

    info "\nDo you want to install the components in Brewfile.home?"
    read -r -p "Install Brewfile.home (${BREW_HOME}): " input
    BREW_HOME=$(echo "${input:-$BREW_HOME}" | awk '{print toupper($0)}')

    info "\nDo you want to install the components in Brewfile.music?"
    read -r -p "Install Brewfile.music (${BREW_MUSIC}): " input
    BREW_MUSIC=$(echo "${input:-$BREW_MUSIC}" | awk '{print toupper($0)}')

    info "\nDo you want to install the components in Brewfile.work?"
    read -r -p "Install Brewfile.work (${BREW_WORK}): " input
    BREW_WORK=$(echo "${input:-$BREW_WORK}" | awk '{print toupper($0)}')

    info "\nDo you want to install the components in Brewfile.java?"
    read -r -p "Install Brewfile.java (${BREW_JAVA}): " input
    BREW_JAVA=$(echo "${input:-$BREW_JAVA}" | awk '{print toupper($0)}')

    # Update the DB with the data we just collected.
    sqlite3 "${db}" "
        UPDATE userdata SET
            repo_dir = '${REPO_DIR}',
            my_name = '${MY_NAME}',
            my_email = '${MY_EMAIL}',
            work_email = '${WORK_EMAIL}',
            company = '${COMPANY}',
            brew_home = '${BREW_HOME}',
            brew_music = '${BREW_MUSIC}',
            brew_work = '${BREW_WORK}',
            brew_java = '${BREW_JAVA}'
        WHERE id = 1;"
}

show_data() {
    echo -e "\n${C_GRAY}We will use the following data:${C_RESET}\n"
    echo -e "${C_GRAY}Repo Dir:   ${C_YELLOW}${REPO_DIR}${C_RESET}"
    echo -e "${C_GRAY}Name:       ${C_YELLOW}${MY_NAME}${C_RESET}"
    echo -e "${C_GRAY}Email:      ${C_YELLOW}${MY_EMAIL}${C_RESET}"
    echo -e "${C_GRAY}Work Email: ${C_YELLOW}${WORK_EMAIL}${C_RESET}"
    echo -e "${C_GRAY}Company:    ${C_YELLOW}${COMPANY}${C_RESET}"
    echo -e "${C_GRAY}Install Brewfile.home: ${C_YELLOW}${BREW_HOME}${C_RESET}"
    echo -e "${C_GRAY}Install Brewfile.music: ${C_YELLOW}${BREW_MUSIC}${C_RESET}"
    echo -e "${C_GRAY}Install Brewfile.work: ${C_YELLOW}${BREW_WORK}${C_RESET}"
    echo -e "${C_GRAY}Install Brewfile.java: ${C_YELLOW}${BREW_JAVA}${C_RESET}"
    echo -e "\n${C_GRAY}If this looks wrong, run ${C_YELLOW}setup.sh -u${C_GRAY} to update.${C_RESET}"
}

do_bash_stuff() {
    local bashrc=${HOME}/.bashrc
    # Backup the existing .bashrc if necessary.
    if file_exists "${bashrc}" && ! is_symlink "${bashrc}"; then
        backup_file "${bashrc}"
    fi
    # Create symlink to our .bashrc file.
    if ! file_exists "${bashrc}"; then
        info "Creating symlink for ~/.bashrc"
        ln -s -f "${my_dir}/conf/bash/.bashrc" "${bashrc}"
    fi

    success "Configured bash"
}

do_zsh_stuff() {
    local zshrc=${HOME}/.zshrc
    # Backup the existing .zshrc if necessary.
    if file_exists "${zshrc}" && ! is_symlink "${zshrc}"; then
        backup_file "${zshrc}"
    fi
    # Create symlink to our .zshrc file.
    if ! file_exists "${zshrc}"; then
        info "Creating symlink for ~/.zshrc"
        ln -s -f "${my_dir}/conf/zsh/.zshrc" "${zshrc}"
    fi

    local zprofile=${HOME}/.zprofile
    # Backup the existing .zprofile if necessary.
    if file_exists "${zprofile}" && ! is_symlink "${zprofile}"; then
        backup_file "${zprofile}"
    fi
    # Create symlink to our .zprofile file.
    if ! file_exists "${zprofile}"; then
        info "Creating symlink for ~/.zprofile"
        ln -s -f "${my_dir}/conf/zsh/.zprofile" "${zprofile}"
    fi

    success "Configured zsh"
}

do_starship_stuff() {
    local cfg=${HOME}/.config/starship.toml
    # Backup the existing config if necessary.
    if file_exists "${cfg}" && ! is_symlink "${cfg}"; then
        backup_file "${cfg}"
    fi
    # Create symlink to our theme.
    if ! file_exists "${cfg}"; then
        info "Creating symlink for starship config"
        ln -s -f "${my_dir}/conf/starship/starship.toml" "${cfg}"
    fi

    success "Configured starship"
}

# do_omz_stuff() {
#     local theme=${HOME}/.oh-my-zsh/themes/my.zsh-theme
#     # Backup the existing theme if necessary.
#     if file_exists "${theme}" && ! is_symlink "${theme}"; then
#         backup_file "${theme}"
#     fi
#     # Create symlink to our theme.
#     if ! file_exists "${theme}"; then
#         info "Creating symlink for oh-my-zsh theme"
#         ln -s -f "${my_dir}/conf/zsh/my.zsh-theme" "${theme}"
#     fi

#     success "Configured oh-my-zsh"
# }

do_brew_stuff() {
    local v=""
    if [[ ${verbose} = true ]]; then
        v="--verbose";
    fi

    info "Installing Brewfile.base"
    brew bundle "${v}" --file "${my_dir}/brew/Brewfile.base"
    if [[ "${BREW_HOME}" == 'Y' ]]; then
        info "\nInstalling Brewfile.home"
        brew bundle "${v}" --file "${my_dir}/brew/Brewfile.home"
    fi
    if [[ "${BREW_MUSIC}" == 'Y' ]]; then
        info "\nInstalling Brewfile.music"
        brew bundle "${v}" --file "${my_dir}/brew/Brewfile.music"
    fi
    if [[ "${BREW_WORK}" == 'Y' ]]; then
        info "\nInstalling Brewfile.work"
        brew bundle "${v}" --file "${my_dir}/brew/Brewfile.work"
    fi
    if [[ "${BREW_JAVA}" == 'Y' ]]; then
        info "\nInstalling Brewfile.java"
        brew bundle "${v}" --file "${my_dir}/brew/Brewfile.java"
    fi

    info "\nUpdating brew casks"
    brew cu --cleanup
    success "Done updating brew casks"
    info "\nUpdating packages not in your Brewfiles..."
    brew upgrade
    success "Done updating packages"
    info "\nCleaning up..."
    brew cleanup
    success "Done cleaning up"
}

do_aws_stuff() {
    local awsdir=${HOME}/.aws
    # Create ~/.aws if it doesn't exist.
    if ! dir_exists "${awsdir}"; then
        info "Creating directory ${awsdir}"
        mkdir -p "${awsdir}"
    fi

    # Create hard link to our config.
    # Uses a hard link instead of a symlink so it can be used in a docker volume mount.
    local awscfg=${awsdir}/config
    if ! file_exists "${awscfg}"; then
        info "Creating hard link for ~/.aws/config"
        ln -f "${my_dir}/conf/aws/config" "${awscfg}"
    fi

    success "Configured awscli"
}

do_git_stuff() {
    local git_root=${HOME}/${REPO_DIR}

    # Create the git repo directories if they don't exist.
    local personal="${git_root}/personal"
    if ! dir_exists "${personal}"; then
        info "Creating ${personal}"
        mkdir -p "${personal}"
    fi
    local public="${git_root}/public"
    if ! dir_exists "${public}"; then
        info "Creating ${public}"
        mkdir -p "${public}"
    fi
    WORK_GIT="${git_root}/${COMPANY}"
    if ! dir_exists "${WORK_GIT}"; then
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
    if python3 --version &> /dev/null; then
        if ! dir_exists "${HOME}/venvs/python3"; then
            info "Creating python virtual env"
            mkdir -p "${HOME}/venvs/python3"
            python3 -m venv "${HOME}/venvs/python3"
        fi
        if dir_exists "${HOME}/venvs/python3"; then
            info "Updating python virtual env"
            # shellcheck disable=SC1091
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
    # shellcheck disable=SC1091
    source "${my_dir}/scripts/helpers.sh"

    # Path to the sqlite database that stores user data.
    db="${my_dir}/dotfiles.db"
    # Preference args defaults.
    update=false   # update user data
    verbose=false  # verbosity

    # Parse arguments.
    while getopts huv flag; do
        case "${flag}" in
            u) update=true;;
            v) verbose=true;;
            h|*) help;;
        esac
    done

    validate_prereqs

    # Create the database if necessary.
    if ! file_exists "${db}"; then
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
    # do_omz_stuff - removed, using starship instead of my OMZ theme

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
