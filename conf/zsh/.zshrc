# oh-my-zsh
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="jjeffers"
plugins=(docker git kubectl)

# brew shell completion -- must be called before oh-my-zsh
# https://docs.brew.sh/Shell-Completion
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

source $ZSH/oh-my-zsh.sh
source "/opt/homebrew/opt/kube-ps1/share/kube-ps1.sh"

# Path additions
# Sublime Text
path+=("/Applications/Sublime Text.app/Contents/SharedSupport/bin")
# Go
export GOPATH=$HOME/go
path+=("$HOME/go/bin")
# Python
path+=("$HOME/venvs/python3/bin")
# Linkerd
path+=($HOME/.linkerd2/bin)
export PATH

# k8s aliases
alias watch="watch "
alias kgn="kubectl get nodes -L node-group-name | sort -k6"
alias kns="kubens"
# AWS aliases
SSO_PROFILE=airdna-dev
alias ssologin="aws sso login --profile $SSO_PROFILE"
alias ecrlogin="aws ecr get-login-password --profile $SSO_PROFILE | docker login --username AWS --password-stdin 537022569116.dkr.ecr.us-east-1.amazonaws.com"
alias npmlogin="aws codeartifact login --profile $SSO_PROFILE --tool npm --repository npm --domain airdna-svc --domain-owner 537022569116"
alias catoken="aws codeartifact get-authorization-token --profile airdna-dev --domain airdna-svc --domain-owner 537022569116 --query authorizationToken --output text"
alias pypiurl="export PYPI_URL=https://aws:$(catoken)@airdna-svc-537022569116.d.codeartifact.us-east-1.amazonaws.com/pypi/pypi/simple/"
alias pypilogin="aws codeartifact login --profile $SSO_PROFILE --tool pip --repository pypi --domain airdna-svc --domain-owner 537022569116"
# My aliases
alias swup="$HOME/git/personal/dotfiles/setup.sh"
