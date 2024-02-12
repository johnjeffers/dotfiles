# dotfiles

Stuff to make it more convenient to configure and update my computers.

> [!WARNING]
> **This is written for my personal needs.** The software and config files it installs are unlikely to be exactly what you want or need. It might be a good place to get ideas for your own setup scripts, though.<br><br>**This has only been tested on MacOS.** Some of this might work on Linux or Windows, but I don't know.

## Prerequisites

1. Install [brew](https://brew.sh).
    ```
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```
1. Install git.
    ```
    brew install git
    ```
1. Install [oh-my-zsh](http://ohmyz.sh).
    ```
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    ```
1. Log in to the Mac App Store. This is required because some software is installed with [brew mas](https://formulae.brew.sh/formula/mas).

## Instructions

Run `./setup.sh`

On the initial run, you'll be asked some setup questions. The answers are saved in a sqlite database for future runs.

💾 To update saved user data, run `./setup.sh -u`

🗣️ To enable verbose mode, run `./setup.sh -v`

## How it Works

The script installs and configures software automatically, so I don't have to do it manually. It handles configuration primarily with symlinks to files saved in this repo, and installs and updates software using `brew`.

### Git Configuration

The script creates directories and `.gitconfig` files under `$HOME` that will look something like this:

```
$HOME
├─ .gitconfig  <-- global .gitconfig
└─ git
   ├─ personal/
   ├─ public/
   └─ company-name/
      └─ .gitconfig  <-- work-specific .gitconfig
```

The global `.gitconfig` uses my personal email.

The work-specific `.gitconfig` uses my work email, so commits to repos in that directory do not use my personal email.

### Dotfile Symlinks

The script will create symlinks to dotfiles that configure various programs. Currently, this includes:

* `~/.aws/config`
* `~/.config/starship.toml`
* `~/.bashrc`
* `~/.zprofile`
* `~/.zshrc`

If any of these files already exist, the script will make a backup.

### Other Configuration

* Configure iTerm2 to use the [preferences file](conf/iterm) in this repo
* Create python venv, and run a `pip install` in that venv with the [requirements file](conf/python/requirements.txt).

### Install Software with Brew

After config files are created, the script installs the software in the [brewfiles](brew).

The brewfiles are split into categories. The [minimal](brew/1-minimal.brewfile) brewfile is always installed, while the others are conditional based on answers to the setup script questions.

## Software Updates

One of the aliases in the `.zshrc` file allows you to run the setup script from any directory.
```
alias swup='$HOME/git/personal/dotfiles/setup.sh'
```
Run `swup` regularly to update everything that was installed by the script.

> [!NOTE]
> One exception to the _"update all the things via script"_ dream is software that was installed via `brew cask`. Cask updates have problematic in my experience, and I had enough issues to give up on it. Apps installed by cask should be updated via their standard (usually in-app) update methods.<br><br>If you'd like to try letting cask update the apps, find the `brew cu --cleanup` line in the script and change it to `brew cu --all`.
