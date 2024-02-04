#!/usr/bin/env zsh
# shellcheck disable=1071,2034,2154

### Customize the zsh stax highlighter to make it less obnoxious
# https://github.com/zsh-users/zsh-stax-highlighting/blob/master/docs/highlighters/main.md

s_pastel="fg=#80a2cd"
s_baby="fg=#a2c4ef"
s_orange="fg=#ffaf00"
s_green="fg=#87d700"
s_mint="fg=#a9f9bb"
s_red="fg=#ff5b56"
s_tulip="fg=#ff8f89"
s_grey="fg=#8a8a8a"

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main cursor)
typeset -gA ZSH_HIGHLIGHT_STYLES

# Set the cursor style
ZSH_HIGHLIGHT_STYLES[cursor]='standout'

# commands, functions, and builtins
ZSH_HIGHLIGHT_STYLES[precommand]=none 	                           # precommand modifiers (noglob, builtin)
ZSH_HIGHLIGHT_STYLES[command]="${s_pastel}"                        # standard commands
ZSH_HIGHLIGHT_STYLES[builtin]="${s_pastel}"                        # builtin commands (echo, pwd)
ZSH_HIGHLIGHT_STYLES[hashed-command]=none                          # hashed commands
ZSH_HIGHLIGHT_STYLES[reserved-word]="${s_pastel}"                  # reserved shell words (if, for)
ZSH_HIGHLIGHT_STYLES[function]="${s_pastel}"                       # user-defined functions

# aliases
ZSH_HIGHLIGHT_STYLES[alias]="${s_pastel}"                          # standard alias
ZSH_HIGHLIGHT_STYLES[suffix-alias]="${s_pastel}"                   # alias -s "foo"
ZSH_HIGHLIGHT_STYLES[global-alias]="${s_pastel}"	               # alias -g "foo"

# paths and globs
ZSH_HIGHLIGHT_STYLES[path]=none                                    # directory paths
ZSH_HIGHLIGHT_STYLES[globbing]="${s_green}"                        #  *.txt, foo??.* (only highlights * and ?)

# parameters
ZSH_HIGHLIGHT_STYLES[assign]="${s_baby}"                           # param assignments (x=foo)
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]="${s_mint}"             #  -o
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]="${s_mint}"             #  -option

# quoted strings
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]="${s_baby}"           #  "foo"
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]="${s_baby}"           #  'foo'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]="${s_baby}"           #  $'foo'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]="${s_orange}"    # \ escapes in double-quotes (\" in foo \"bar\"")
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]="${s_orange}"    # \ escapes in dollar quotes (\x in $'\x48')
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]="${s_orange}"  # param expansion in double-quotes ($foo in "$foo")

# redirection, substitution, and separators
ZSH_HIGHLIGHT_STYLES[commandseparator]="${s_tulip}"                # command separation tokens (; &&)
ZSH_HIGHLIGHT_STYLES[redirection]="${s_tulip}"                     # redirection operators (<. >)
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]="${s_green}"  #  $(foo -o bar)

# syntax errors or things that probably shouldn't be used.
ZSH_HIGHLIGHT_STYLES[unknown-token]="${s_red}"                     # unknown token or errors
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]="${s_red}"              #  `foo`
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-unclosed]="${s_red}"     #  `foo
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]="${s_red}"    #  `
ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]="${s_red}"   #  'foo
ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]="${s_red}"   #  "foo
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]="${s_red}"   #  $'foo

# comments
ZSH_HIGHLIGHT_STYLES[comment]="${s_grey}"

# default
ZSH_HIGHLIGHT_STYLES[default]=none                                 # everything else
