#!/usr/bin/env zsh

get_configs() {
  # Make sure the array is empty before we do anything else.
  unset CONFIGS
  # Read the files in ~/.kube (ignore 'config')
  while IFS=' ' read -r line; do
    CONFIGS+=("$line")
  done < <(find "${HOME}/.kube" -maxdepth 1 -type f -exec basename {} \; | sort | grep -v config)
}

# Parse the files in ~/.kube and select a kubeconfig to activate.
kset() {
  PS3="Select kubeconfig: "

  get_configs
  select config in "${CONFIGS[@]}"; do
    [ "$config" ] &&
      {
        KUBECONFIG="${HOME}/.kube/${config}"
        export KUBECONFIG
        break
      }
    {
      echo "Invalid option!"
      break
    }
  done
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
