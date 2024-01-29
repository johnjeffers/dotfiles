#!/usr/bin/env zsh
# shellcheck disable=1071,2034,2154

### Customize the zsh syntax highlighter to make it less obnoxious

# no color
ZSH_HIGHLIGHT_STYLES[assign]=none
ZSH_HIGHLIGHT_STYLES[default]=none
ZSH_HIGHLIGHT_STYLES[hashed-command]=none
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[precommand]=none

# blue
ZSH_HIGHLIGHT_STYLES[alias]=fg=#80a2cd
ZSH_HIGHLIGHT_STYLES[builtin]=fg=#80a2cd
ZSH_HIGHLIGHT_STYLES[command]=fg=#80a2cd
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=#80a2cd
ZSH_HIGHLIGHT_STYLES[function]=fg=#80a2cd
ZSH_HIGHLIGHT_STYLES[global-alias]=fg=#80a2cd
ZSH_HIGHLIGHT_STYLES[globbing]=fg=#80a2cd
ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=#80a2cd
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=#80a2cd
ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=#80a2cd

# green
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=112
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=112

# orange
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=214
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=214
ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=214
ZSH_HIGHLIGHT_STYLES[command-substituion]=fg=214
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=214
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=214
ZSH_HIGHLIGHT_STYLES[redirection]=fg=214

# red
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=fg=red
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-unclosed]=fg=red
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]=fg=red
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]=fg=red
ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]=fg=red
ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]=fg=red
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red
