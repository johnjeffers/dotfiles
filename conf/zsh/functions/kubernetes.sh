#!/usr/bin/env bash

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

# unset the KUBECONFIG env var
kunset() {
    unset KUBECONFIG
}

# Grep for nodes, show the header, sort by zone.
kgngrep() {
    if [[ $# -eq 0 ]]; then
        echo "grep pattern is required"
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
        echo "namespace prefix filter is required"
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
