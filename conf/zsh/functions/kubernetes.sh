#!/usr/bin/env zsh
# shellcheck disable=2154

# Parse the files in ~/.kube and select a kubeconfig to activate.
kset() {
    files=()
    PS3="Select kubeconfig: "
    while IFS=' ' read -r line; do files+=("$line"); done < <(find "${HOME}/.kube" -maxdepth 1 -type f -exec basename {} \; | sort)
    select file in "${files[@]}"; do
        [ "$file" ] &&
        {
            KUBECONFIG="${HOME}/.kube/${file}"
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

    if [[ "${#ns[@]}" -eq 0 ]]; then
        echo "No namespaces found with filter \"${1}\""
        return
    else
        echo "Looking for empty namespaces..."
        for n in "${ns[@]}" ; do
            if ! [[ "$(kubectl get deployment -n "${n}" -o name)" ]]; then
                echo "Deleting: ${n}"
                kubectl delete ns "${n}"
            fi
        done
    fi
}


# eks-node-viewer helper.
nodeview() {
    # $1 = env $2 = region
    if [[ $# -lt 2 ]]; then
        echo -e "eks-node-viewer helper. Invokes eks-node-viewer with some preconfigured params useful to me.\n"
        echo "usage: ${funcstack} [env=dev|prod|svc] [region]"
        return
    fi

    AWS_PROFILE="fusionauth-${1}-admin" eks-node-viewer --kubeconfig "${HOME}/.kube/fusionauth-${1}-${2}" --extra-labels node-group-name --resources cpu,memory
}
