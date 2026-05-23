#!/usr/bin/env bash

kubeconfig="${KUBECONFIG:-$HOME/.kube/config}"

# Simple version: use first file if KUBECONFIG has multiple entries.
case "$kubeconfig" in
*:*) kubeconfig="${kubeconfig%%:*}" ;;
esac

[ -r "$kubeconfig" ] || exit 1
command -v yq >/dev/null 2>&1 || exit 1

ctx="$(yq -r '."current-context" // ""' "$kubeconfig")"
[ -n "$ctx" ] || exit 1

cluster="$(
    ctx="$ctx" yq -r '
        (.contexts[] | select(.name == strenv(ctx)) | .context.cluster) // ""
    ' "$kubeconfig"
)"

ns="$(
    ctx="$ctx" yq -r '
        (.contexts[] | select(.name == strenv(ctx)) | .context.namespace) // "namespace-unset"
    ' "$kubeconfig"
)"

short_ctx="$ctx"

declare -A aliases=(
    [fusionauth]=fa
    [cleanspeak]=cs
    [af-south-1]=afs1
    [ap-northeast-2]=apn2
    [ap-southeast-1]=aps1
    [ap-southeast-2]=aps2
    [ca-central-1]=cc1
    [eu-central-1]=euc1
    [eu-north-1]=eun1
    [eu-west-1]=euw1
    [eu-west-2]=euw2
    [eu-west-3]=euw3
    [us-east-1]=use1
    [us-east-2]=use2
    [us-west-2]=usw2
)

for from in "${!aliases[@]}"; do
    short_ctx="${short_ctx//$from/${aliases[$from]}}"
done

if [[ "$ctx" == *prod* || "$cluster" == *prod* ]]; then
    fg='38;5;214'
else
    fg='38;2;224;225;221'
fi

symbol='⎈'
if [[ "$ns" == "namespace-unset" ]]; then
    printf '\033[48;2;79;99;125;%sm %s %s:\033[38;2;160;161;167m%s \033[0m' "$fg" "$symbol" "$short_ctx" "$ns"
else
    printf '\033[48;2;79;99;125;%sm %s %s:%s \033[0m' "$fg" "$symbol" "$short_ctx" "$ns"
fi
