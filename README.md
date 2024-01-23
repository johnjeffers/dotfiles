# dotfiles

Just some stuff to save me setup time when configuring a new mac.

> [!WARNING]
> **This is highly customized for me.** It might be a good place to get ideas for your own scripts, though.<br><br>**This is not going to be right for you as-is.** The software and config files it installs are unlikely to be what you want or need, unless you work at the same company as me. And even then, it won't be exactly right.<br><br>**This has only been tested on MacOS.** Some of this will probably work on Linux or Windows, but I don't know.

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
1. Log in to the Mac App Store. This is needed because some software is installed with [brew mas](https://formulae.brew.sh/formula/mas).

## Instructions

Run `./setup.sh`

On the initial run, you'll be asked some setup questions. The answers will be saved in a sqlite database for future runs.

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

* `~/.bashrc`
* `~/.zshrc`
* `~/.zshenv`
* `~/.aws/config`
* `~/.config/starship.toml`

If the files being replaced already exist, the script will make a backup.

### Other Configuration

* Configure iTerm2 to use the preferences file in this repo
* Create a virtual env for the python installed by brew

### Install Software with Brew

After config files are created, the script installs the software in the Brewfiles.

The Brewfiles are split into `base`, `home`, `work`, and `music`. The `base` Brewfile is always installed, while the others are conditional based on answers to the setup questions.

### Software Updates

One of the aliases in the `.zshrc` file allows you to easily rerun this script from any directory.
```
alias swup='$HOME/git/personal/dotfiles/setup.sh'
```
So, just run `swup` to update everything that was installed with the script.

> [!NOTE]
> One exception to the _"update all the things via script"_ dream is software that was installed via `brew cask`. Cask updates have been sketchy in my experience, and I had enough issues with it to give up on it. So those apps should be updated via their normal (usually in-app) update methods.<br><br>If you'd like to try letting the casks update themselves, find the `brew cu --cleanup` line in the script and change it to `brew cu --all`.
