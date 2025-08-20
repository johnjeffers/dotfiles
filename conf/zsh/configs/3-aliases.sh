#!/usr/bin/env zsh
# shellcheck disable=1071

### Aliases

alias c='clear'
alias swup='~/git/personal/dotfiles/setup.sh'
alias tf='terraform'
alias tfclean='rm .terraform.lock.hcl && rm -rf .terraform'
alias watch='watch '

# k8s aliases
alias kgn='kubectl get nodes -L node-group-name -L topology.kubernetes.io/zone | sort -k6'
alias kns='kubens'
alias wkgn='watch "kubectl get nodes --sort-by=.metadata.creationTimestamp -l eks.amazonaws.com/compute-type!=fargate --no-headers -L node-group-name -L topology.kubernetes.io/zone | tail -r"'
alias wkgpa='watch "kubectl get po --all-namespaces | grep -v '\''Completed'\'' | grep -vE '\''1/1|2/2|3/3|4/4|5/5|6/6'\''"'

# AWS aliases
alias ssologin='aws sso login --profile ${SSO_PROFILE:-fusionauth-dev}'
alias ecrlogin='aws ecr get-login-password --profile ${SSO_PROFILE:-fusionauth-dev} | docker login --username AWS --password-stdin 752443094709.dkr.ecr.us-west-2.amazonaws.com'
# alias npmlogin='aws codeartifact login --profile $SSO_PROFILE --tool npm --repository npm --domain fusionauth-svc --domain-owner 752443094709'
