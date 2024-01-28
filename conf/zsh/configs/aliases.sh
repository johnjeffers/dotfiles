#!/usr/bin/env zsh

### Aliases
# k8s aliases
alias kgn="kubectl get nodes -L node-group-name -L topology.kubernetes.io/zone | sort -k6"
alias kns="kubens"
# AWS aliases
alias ssologin='aws sso login --profile ${SSO_PROFILE:-fusionauth-dev}'
alias ecrlogin='aws ecr get-login-password --profile ${SSO_PROFILE:-fusionauth-dev} | docker login --username AWS --password-stdin 752443094709.dkr.ecr.us-west-2.amazonaws.com'
# alias npmlogin='aws codeartifact login --profile $SSO_PROFILE --tool npm --repository npm --domain fusionauth-svc --domain-owner 752443094709'
# alias pypilogin='aws codeartifact login --profile $SSO_PROFILE --tool pip --repository pypi --domain fusionauth-svc --domain-owner 752443094709'
alias nodeview-dev="AWS_PROFILE=fusionauth-dev-admin eks-node-viewer --kubeconfig ~/.kube/fusionauth-dev-us-west-2 --extra-labels node-group-name --resources cpu,memory"
alias nodeview-prod="AWS_PROFILE=fusionauth-prod-admin eks-node-viewer --kubeconfig ~/.kube/fusionauth-prod-us-east-1 --extra-labels node-group-name --resources cpu,memory"
alias nodeview-svc="AWS_PROFILE=fusionauth-svc-admin eks-node-viewer --kubeconfig ~/.kube/fusionauth-svc-us-west-2 --extra-labels node-group-name --resources cpu,memory"
# Other aliases
alias c="clear"
alias swup='$HOME/git/personal/dotfiles/setup.sh'
alias tf="terraform"
alias watch="watch "
