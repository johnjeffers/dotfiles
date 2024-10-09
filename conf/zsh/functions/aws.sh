#!/usr/bin/env bash

# function ssm-login() {
#   if [[ "$#" -ne 1 ]]; then
#     echo "Usage: ssm-login [hostname]"
#     return
#   fi

#   hostname="${1}"

#   case "${hostname}" in
#     *inversoft.io)   export AWS_PROFILE=cleanspeak-old;;
#     *cleanspeak.io)  export AWS_PROFILE=cleanspeak-prod;;
#     *fusionauth.io)  export AWS_PROFILE=fusionauth-prod;;
#     *fusionauth.dev) export AWS_PROFILE=fusionauth-dev;;
#     *) echo "Unknown domain in hostname '${hostname}'"; return 1;;
#   esac

#   read -r -d '' region arn < <(aws resource-explorer-2 search --query-string "resourcetype:ec2:instance tag.value:${hostname}" --query 'Resources[].[Region,Arn]' --output text)

#   if [[ "$region" == "" || "$arn" == "" ]]; then
#     echo "Could not get SSM connection info for hostname '${hostname}'"
#     return 1
#   fi

#   id="${arn##*/}"
#   echo "Connecting to instance-id ${id} in region ${region}"
#   aws ssm start-session --region "${region}" --target "${id}"
# }

function watch-ec2-state() {
	NAME="${1}"
	PROFILE=${2:-"fusionauth-prod"}
	REGION=${3:-"us-east-1"}
	watch "aws ec2 describe-instances --profile "${PROFILE}" --region "${REGION}" --filters 'Name=tag:Name,Values="${NAME}.*"' --query 'Reservations[*].Instances[*].State.Name' --output=text"
}
