# don't replace the default .bashrc, just add this stuff to the end of it.

# Enable starship
eval "$(starship init bash)"

# History search with arrow keys
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# Add go bin path
export PATH=$PATH:$HOME/go/bin

### Aliases

# General aliases
alias c="clear"
alias l="ls -lah"
alias watch="watch "

# git aliases
alias gaa="git add ."
alias gcam="git commit -am"
alias gcm="git checkout main"
alias gco="git checkout"
alias gd="git diff"
alias gds="git diff --staged"
alias gfa="git fetch --all"
alias gl="git pull"
alias gp="git push"
alias gst="git status"

# k8s aliases
alias k="kubectl"
alias kgd="kubectl get deployments"
alias kgda="kubectl get deployments -A"
alias kgn='kubectl get nodes -L node-group-name -L topology.kubernetes.io/zone | sort -k6'
alias kgp="kubectl get pods"
alias kgpa="kubectl get pods -A"
alias kgs="kubectl get svc"
alias kgsa="kubectl get svc -A"
alias kns='kubens'
alias wkgn='watch "kubectl get nodes --sort-by=.metadata.creationTimestamp -l eks.amazonaws.com/compute-type!=fargate --no-headers -L node-group-name -L topology.kubernetes.io/zone | tail -r"'
alias wkgpa='watch "kubectl get po --all-namespaces | grep -v '\''Completed'\'' | grep -vE '\''1/1|2/2|3/3|4/4|5/5|6/6'\''"'

# terraform aliases
alias tf="terraform"
alias tfclean="rm -rf .terraform .terraform.lock.hcl"

# AWS aliases
alias ssologin='aws sso login --profile ${SSO_PROFILE:-fusionauth-svc-admin}'
alias ecrlogin='aws ecr get-login-password --profile ${SSO_PROFILE:-fusionauth-svc-admin} | docker login --username AWS --password-stdin 752443094709.dkr.ecr.us-west-2.amazonaws.com'

