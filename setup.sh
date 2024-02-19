#!/usr/bin/env bash
# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail

# Get the path this script lives in so it'll work if called from another directory.
MY_DIR=$(cd -- "$(dirname "$0")" >/dev/null 2>&1; pwd -P)
cd "${MY_DIR}"

help() {
    printf "usage: setup.sh [-hdv]\n\n"
    printf "    -h  show this help\n"
    printf "    -d  enable debug output (set -xv)\n\n"
    printf "    -v  enable verbose output\n"
    printf "Run 'setup.sh -dv' for maximum verbosity.\n"
    exit
}


# We have to do this check before we source our helper functions,
# so we need to use regular echo with color codes here.
bash_version_check() {
    if ((BASH_VERSINFO[0] < 4)); then
        echo -e "$(tput setaf 202)bash version ${BASH_VERSION} detected. You need bash version 4 or later.$(tput sgr0)\n"
        echo -e "$(tput setaf 248)Run $(tput sgr0)brew install bash$(tput sgr0) $(tput setaf 248)and try again.$(tput sgr0)"
        exit 1
    fi
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


setup_bash() {
    local bashrc=${HOME}/.bashrc

    if file_exists "${bashrc}" && not_symlink "${bashrc}"; then
        archive_file "${bashrc}"
    fi
    if file_missing "${bashrc}"; then
        create_softlink "${MY_DIR}/conf/bash/.bashrc" "${bashrc}"
    fi

    success "Configured bash"
}


setup_zsh() {
    local zshrc=${HOME}/.zshrc
    if file_exists "${zshrc}" && not_symlink "${zshrc}"; then
        archive_file "${zshrc}"
    fi
    if file_missing "${zshrc}"; then
        create_softlink "${MY_DIR}/conf/zsh/.zshrc" "${zshrc}"
    fi

    local zprofile=${HOME}/.zprofile
    if file_exists "${zprofile}" && not_symlink "${zprofile}"; then
        archive_file "${zprofile}"
    fi
    if file_missing "${zprofile}"; then
        create_softlink "${MY_DIR}/conf/zsh/.zprofile" "${zprofile}"
    fi

    success "Configured zsh"
}


setup_starship() {
    # Install fonts used by iTerm2/Starship.
    fonts="MonacoNerdFont-Regular.ttf MonacoNerdFontMono-Regular.ttf"
    for font in $fonts; do
        if file_missing "${HOME}/Library/Fonts/${font}"; then
            info "Installing font ${font}..."
            cp "${MY_DIR}/fonts/${font}" "${HOME}/Library/Fonts"
        fi
    done

    local cfg=${HOME}/.config/starship.toml
    # Backup the existing config if necessary.
    if file_exists "${cfg}" && not_symlink "${cfg}"; then
        archive_file "${cfg}"
    fi
    # Create symlink to our theme.
    if file_missing "${cfg}"; then
        create_softlink "${MY_DIR}/conf/starship/starship.toml" "${cfg}"
    fi

    success "Configured starship"
}


run_brew() {
    local v=""
    if [[ ${verbose} = true ]]; then v="--verbose"; fi

    info "\nInstalling minimal brewfile"
    brew bundle "${v}" --file "${MY_DIR}/brew/minimal.brewfile"
    if "${BREW_BASE}"; then
        info "\nInstalling base brewfile"
        brew bundle "${v}" --file "${MY_DIR}/brew/base.brewfile"
    fi
    if "${BREW_HOME}"; then
        info "\nInstalling home brewfile"
        brew bundle "${v}" --file "${MY_DIR}/brew/home.brewfile"
    fi
    if "${BREW_MUSIC}"; then
        info "\nInstalling music brewfile"
        brew bundle "${v}" --file "${MY_DIR}/brew/music.brewfile"
    fi
    if "${BREW_WORK}"; then
        info "\nInstalling work brewfile"
        brew bundle "${v}" --file "${MY_DIR}/brew/work.brewfile"
    fi

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


setup_ssh() {
    local sshdir="${HOME}/.ssh"
    if dir_missing "${sshdir}"; then
        create_directory "${sshdir}"
    fi

    local config="${sshdir}/config"
    if file_exists "${config}" && not_symlink "${config}"; then
        archive_file "${config}"
    fi
    if file_missing "${config}"; then
        create_softlink "${MY_DIR}/conf/ssh/config" "${config}"
    fi

    success "Configured ssh"
}


setup_aws() {
    local awsdir="${HOME}/.aws"

    if dir_missing "${awsdir}"; then
        create_directory "${awsdir}"
    fi

    # Create hard link to our config.
    # Uses a hard link instead of a symlink so it can be used in a docker volume mount.
    local awscfg=${awsdir}/config
    if file_missing "${awscfg}"; then
        create_hardlink "${MY_DIR}/conf/aws/config" "${awscfg}"
    fi

    success "Configured awscli"
}


setup_git() {
    # Create the git directories if they don't exist
    # Strips quotes in case ~ is being used instead of $HOME
    local dirs=(
        "${MY_REPOS//\"/}"
        "${PUBLIC_REPOS//\"/}"
        "${WORK_REPOS//\"/}"
    )
    for dir in "${dirs[@]}"; do
        if dir_missing "${dir}"; then
            create_directory "${dir}"
        fi
    done

    # Some vars need to be exported to work with envsubst.
    export MY_NAME MY_EMAIL WORK_REPOS WORK_NAME WORK_EMAIL PUBLIC_REPOS PUBLIC_NAME PUBLIC_EMAIL
    envsubst < "${MY_DIR}/conf/git/.gitconfig.global" > "${HOME}/.gitconfig"
    envsubst < "${MY_DIR}/conf/git/.gitconfig.public" > "${PUBLIC_REPOS}/.gitconfig"
    envsubst < "${MY_DIR}/conf/git/.gitconfig.work" > "${WORK_REPOS}/.gitconfig"

    success "Configured git"
}


setup_iterm() {
    # Configure iTerm to use our preferences file.
    if dir_exists "/Applications/iTerm.app"; then
        defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$MY_DIR/conf/iterm"
        defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
        success "Configured iterm"
    else
        error "Cannot find iterm!"
    fi
}


setup_python() {
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
            if [[ "${verbose}" = true ]]; then
                pip install -U --index-url https://pypi.org/simple pip
                pip install -U --index-url https://pypi.org/simple -r "${MY_DIR}/conf/python/requirements.txt"
            else
                # Pipe pip to grep to suppress output if there are no updates.
                pip install -U --index-url https://pypi.org/simple pip | { grep -v 'Requirement already satisfied' || true; }
                pip install -U --index-url https://pypi.org/simple -r "${MY_DIR}/conf/python/requirements.txt" | { grep -v 'Requirement already satisfied' || true; }
            fi
            deactivate
        fi
        success "Configured python"
    else
        error "Cannot find python!"
    fi
}


main() {
    bash_version_check
    source "${MY_DIR}/scripts/helpers.sh"
    
    verbose=false  # verbosity
    debug=false    # set -xv

    # Parse arguments.
    while getopts hdv flag; do
        case "${flag}" in
            d) debug=true;;
            v) verbose=true;;
            h|*) help;;
        esac
    done

    if [[ "${debug}" = true ]]; then set -xv; fi

    # Make sure the .env file exists
    if file_exists "${MY_DIR}/.env"; then
        source "${MY_DIR}/.env"
    else
        error "Missing .env file!\n"
        info "Run 'cp .env.template .env'"
        info "Edit .env to fill in your details and preferences."
        exit 1
    fi

    validate_prereqs

    if "${SETUP_BASH}";     then setup_bash;     fi
    if "${SETUP_ZSH}";      then setup_zsh;      fi
    if "${SETUP_STARSHIP}"; then setup_starship; fi
    if "${RUN_BREW}";       then run_brew;       fi
    if "${SETUP_SSH}";      then setup_ssh;      fi
    if "${SETUP_AWS}";      then setup_aws;      fi
    if "${SETUP_GIT}";      then setup_git;      fi
    if "${SETUP_ITERM}";    then setup_iterm;    fi
    if "${SETUP_PYTHON}";   then setup_python;   fi

    success "\nDone!"
}

main "$@"
