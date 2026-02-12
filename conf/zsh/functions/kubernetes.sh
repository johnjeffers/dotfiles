#!/usr/bin/env zsh

get_configs() {
  # Make sure the array is empty before we do anything else.
  unset CONFIGS
  # Read the files in ~/.kube (ignore 'config')
  while IFS=' ' read -r line; do
    CONFIGS+=("$line")
  done < <(find "${HOME}/.kube" -maxdepth 1 -type f -exec basename {} \; | sort | grep -v config)
}

# Wrapper around k9s. Makes all the kubeconfig files available.
k9start() {
  get_configs
  all_configs=""
  for config in "${CONFIGS[@]}"; do
    all_configs+=$(echo -n "~/.kube/$config:")
  done
  # In this case we do want ~/.kube/config
  eval "KUBECONFIG=${all_configs}~/.kube/config k9s --logoless $@"
}

# Parse the files in ~/.kube and select a kubeconfig to activate.
kset() {
  get_configs

  if [[ $# -ge 1 ]]; then
    local n="$1"
  else
    local items=()
    local i
    for i in {1..${#CONFIGS[@]}}; do
      items+=("$i) ${CONFIGS[$i]}")
    done
    print -c -- "${items[@]}"
    echo ""
    echo -n "Select kubeconfig: "
    read -r n
  fi

  if [[ "$n" -ge 1 && "$n" -le ${#CONFIGS[@]} ]] 2>/dev/null; then
    KUBECONFIG="${HOME}/.kube/${CONFIGS[$n]}"
    export KUBECONFIG
    echo "Switched to ${CONFIGS[$n]}"
  else
    echo "Invalid option."
  fi
}

# Unset the KUBECONFIG env var.
kunset() {
  unset KUBECONFIG
}

kimage() {
  if [[ $# -ne 3 ]]; then
    echo -e "Get image in use across multiple clusters.\n"
    echo "usage: ${funcstack} [deployment|daemonset|statefulset] [namespace] [name]"
    return
  fi

  KIND="$1" # deployment|statefulset|daemonset
  NAMESPACE="$2"
  NAME="$3"

  get_configs
  for config in "${CONFIGS[@]}"; do
    echo "$config:"
    KUBECONFIG=~/.kube/"$config" kubectl get -n "$NAMESPACE" "$KIND" "$NAME" \
      -o=jsonpath='{$.spec.template.spec.containers[:1].image}'
    echo ""
    echo ""
  done
}

# Deletes empty namespaces.
# Requires one arg, which is the prefix start string.
kns-cleanup() {
  if [[ $# -eq 0 ]]; then
    echo -e "Deletes empty namespaces starting with [prefix].\n"
    echo "usage: ${funcstack} [prefix]"
    return
  fi

  ns=()
  while IFS='' read -r line; do ns+=("$line"); done < <(kubectl get ns --no-headers -o custom-columns=":metadata.name" | grep "^$1")

  if [[ ${#ns[@]} -eq 0 ]]; then
    echo "No namespaces found with filter \"${1}\""
    return
  else
    echo "Looking for empty namespaces..."
    for n in "${ns[@]}"; do
      if ! [[ "$(kubectl get deployment -n "${n}" -o name)" ]]; then
        echo "Deleting: ${n}"
        kubectl delete ns "${n}"
      fi
    done
  fi
}


# Set do-not-evict annotation on all gha-runners
kprotect-runner-nodes() {
  echo "Finding nodes running pods with names containing '-runner-'..."

  nodes=$(kubectl get pods --all-namespaces -o json \
    | jq -r '.items[] | select(.metadata.name | test("-runner-")) | .spec.nodeName' \
    | sort -u)

  if [ -z "$nodes" ]; then
    echo "No nodes found"
    return 0
  fi

  echo "Setting annotation 'karpenter.sh/do-not-evict=true'"
  echo "$nodes" | while IFS= read -r node; do
    echo -e "\n- $node"
    kubectl annotate node "$node" karpenter.sh/do-not-evict=true --overwrite || {
      echo "⚠️ failed to annotate $node"
    }
  done
}


kunprotect-runner-nodes() {
  local nodes
  nodes=$(kubectl get nodes -o json \
    | jq -r '.items[] | select(.metadata.annotations["karpenter.sh/do-not-evict"] == "true") | .metadata.name')

  if [[ -z "$nodes" ]]; then
    echo "No nodes found"
    return 0
  fi

  echo "Removing annotation 'karpenter.sh/do-not-evict'"
  echo "$nodes" | while IFS= read -r node; do
    echo -e "\n- $node"
    kubectl annotate node "$node" karpenter.sh/do-not-evict- --overwrite || {
      echo "⚠️ failed to remove annotation from $node"
    }
  done
}


kcleanup() {
  local mode="$1"
  local filter

  if [[ "$mode" != "failed" && "$mode" != "restarted" ]]; then
    echo "Usage: $0 <failed|restarted>"
    return 1
  fi

  if [[ "$mode" == "failed" ]]; then
    filter="ContainerStatusUnknown|Error|Failed"
  else
    filter="ago)"
  fi

  local namespaces=(
    "grafana-net"
    "groundcover"
    "kube-system"
  )

  for namespace in "${namespaces[@]}"; do
    echo -e "\ncleaning namespace: $namespace"
    kubectl get pods --namespace "$namespace" | grep -E "$filter" | awk '{print $1, $2}' | \
      xargs -n 2 sh -c 'echo - Deleting '"$namespace"'/$0 ... && kubectl delete pod --namespace '"$namespace"' $0 > /dev/null 2>&1'
  done
}


# Grep for nodes, show the header, sort by zone.
nodegrep() {
  if [[ $# -eq 0 ]]; then
    echo "usage: ${funcstack} [pattern]"
    return
  fi

  nodes="$(kubectl get nodes -L node-group-name -L topology.kubernetes.io/zone)"
  echo "${nodes}" | head -n1
  echo "${nodes}" | grep -i "${1}" | sort -k7
}

# Use EC2 connect to SSH to an EKS node.
nodessh() {
  if ! [[ $# -eq 2 ]]; then
    echo "usage: ${funcstack} [aws-profile-name] [node-name]"
    return
  fi

  aws ec2-instance-connect ssh \
    --profile "${1}" \
    --connection-type direct \
    --instance-id "$(kubectl get no "${2}" -o jsonpath='{.spec.providerID}' | cut -d '/' -f 5)"
}

# eks-node-viewer helper.
nodeview() {
  # $1 = env $2 = region
  if [[ $# -lt 2 ]]; then
    echo -e "eks-node-viewer helper. Invokes eks-node-viewer with some preconfigured params useful to me.\n"
    echo "usage: ${funcstack} [env=dev|prod|svc] [region]"
    return
  fi

  AWS_PROFILE="fusionauth-${1}-admin" eks-node-viewer \
    --kubeconfig "${HOME}/.kube/fusionauth-${1}-${2}" \
    --extra-labels node-group-name \
    --resources cpu,memory
}

# SSM login to EKS node.
nodessm() {
  if ! [[ $# -eq 1 ]]; then
    echo "usage: ${funcstack} [ip]"
    return
  fi

  local nodeip
  nodeip="${1//./-}"
  local profile
  profile="$(kubectl config view -o jsonpath='{.users[0].user.exec.env[].value}')"
  local region
  region="$(kubectl config view -o jsonpath='{.users[0].name}' | cut -d ':' -f 4,4)"

  # Node name is different in us-east-1.
  local node
  if [[ ${region} == "us-east-1" ]]; then
    node="ip-${nodeip}.ec2.internal"
  else
    node="ip-${nodeip}.${region}.compute.internal"
  fi
  local target
  target="$(kubectl get no "${node}" -o jsonpath='{.spec.providerID}' | cut -d '/' -f 5)"

  aws ssm start-session --profile "${profile}" --region "${region}" --target "${target}"
}
