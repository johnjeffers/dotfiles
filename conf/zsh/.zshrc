# Path additions
# Sublime Text
path+=("/Applications/Sublime Text.app/Contents/SharedSupport/bin")
# Go
export GOPATH=$HOME/go
path+=("$HOME/go/bin")
# Python
path+=("$HOME/venvs/python3/bin")
path+=("/opt/homebrew/opt/postgresql@15/bin")

# k8s aliases
alias watch="watch "
alias kgn="kubectl get nodes -L node-group-name -L topology.kubernetes.io/zone | sort -k6"
alias kns="kubens"
# AWS aliases
alias ssologin='aws sso login --profile ${SSO_PROFILE:-fusionauth-dev}'
alias ecrlogin='aws ecr get-login-password --profile ${SSO_PROFILE:-fusionauth-dev} | docker login --username AWS --password-stdin 752443094709.dkr.ecr.us-west-2.amazonaws.com'
# alias npmlogin='aws codeartifact login --profile $SSO_PROFILE --tool npm --repository npm --domain fusionauth-svc --domain-owner 752443094709'
# alias pypilogin='aws codeartifact login --profile $SSO_PROFILE --tool pip --repository pypi --domain fusionauth-svc --domain-owner 752443094709'
# My aliases
alias nodeview-dev="AWS_PROFILE=fusionauth-dev-admin eks-node-viewer --kubeconfig ~/.kube/fusionauth-dev-us-west-2 --extra-labels node-group-name --resources cpu,memory"
alias nodeview-prod="AWS_PROFILE=fusionauth-prod-admin eks-node-viewer --kubeconfig ~/.kube/fusionauth-prod-us-east-1 --extra-labels node-group-name --resources cpu,memory"
alias nodeview-svc="AWS_PROFILE=fusionauth-svc-admin eks-node-viewer --kubeconfig ~/.kube/fusionauth-svc-us-west-2 --extra-labels node-group-name --resources cpu,memory"
alias swup='$HOME/git/personal/dotfiles/setup.sh'
alias tf="terraform"

# brew shell completion -- must be called before oh-my-zsh
# https://docs.brew.sh/Shell-Completion
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

# oh-my-zsh - https://ohmyz.sh/
# Theme is disabled because of Starship
ZSH_THEME=""
ZSH_DISABLE_COMPFIX=true
export ZSH=$HOME/.oh-my-zsh
plugins=(docker git kubectl)
source $ZSH/oh-my-zsh.sh

# zsh autosuggestions - https://github.com/zsh-users/zsh-autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Starship - https://starship.rs
eval "$(starship init zsh)"
