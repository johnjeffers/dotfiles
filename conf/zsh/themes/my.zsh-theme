#!/usr/bin/env zsh

# Color vars
# NOTE: run spectrum_ls to see all color options
eval user_std='$FG[240]'
eval user_root='$FG[214]'
eval directory='$FG[032]'
eval git_std='$FG[075]'
eval git_clean='$FG[118]'
eval git_dirty='$FG[214]'
eval prompt_char='$FG[105]'
# kube-ps1 colors
eval kube_std='75'
eval kube_prod='214'

# Change color if root
prompt_user() {
    if [[ $(whoami) = "root" ]]; then
        echo -n "$user_root"
    else
        echo -n "$user_std"
    fi
    echo -n "%n%{$reset_color%} "
}

prompt_path() {
    echo -n "$directory%~%{$reset_color%} "
}

prompt_git() {
    ZSH_THEME_GIT_PROMPT_PREFIX="$git_std("
    ZSH_THEME_GIT_PROMPT_CLEAN="$git_clean%{$reset_color%}"
    ZSH_THEME_GIT_PROMPT_DIRTY="$git_dirty ✗%{$reset_color%}"
    ZSH_THEME_GIT_PROMPT_SUFFIX="$git_std)%{$reset_color%}"
    echo -n "$(git_prompt_info) "
}

prompt_k8s() {
    KUBE_PS1_PREFIX=[
    KUBE_PS1_DIVIDER=" "
    KUBE_PS1_SUFFIX=]
    KUBE_PS1_SYMBOL_ENABLE=false
    if [[ $KUBE_PS1_CONTEXT == *"prod"* ]]; then
        KUBE_PS1_PREFIX_COLOR="$kube_prod"
        KUBE_PS1_CTX_COLOR="$kube_prod"
        KUBE_PS1_NS_COLOR="$kube_prod"
        KUBE_PS1_SUFFIX_COLOR="$kube_prod"
    else
        KUBE_PS1_PREFIX_COLOR="$kube_std"
        KUBE_PS1_CTX_COLOR="$kube_std"
        KUBE_PS1_NS_COLOR="$kube_std"
        KUBE_PS1_SUFFIX_COLOR="$kube_std"
    fi
    echo -n "$(kube_ps1)%{$reset_color%}"
}

prompt_main() {
    prompt_user
    prompt_path
    prompt_git
    prompt_k8s
}

# %{%f%b%k%} resets fore/back color & font weight to defaults
# (!.#.») changes prompt char, # if root, » if not
PROMPT='%{%f%b%k%}$(prompt_main)
$prompt_char%(!.#.»)%{$reset_color%} '
