#!/usr/bin/env bash

function terminate-instance-by-ip() {
  local profile="$1"
  local ip="$2"
  local id=""

  if [[ -z "$profile" ]]; then
    echo "Usage: terminate-instance-by-ip <aws-profile> <ip-addr>"
    return 1
  fi

  if [[ -z "$ip" ]]; then
    echo "Usage: terminate-instance-by-ip <aws-profile> <ip-addr>"
    return 1
  fi

  id=$(aws ec2 describe-instances \
    --profile "$profile" \
    --filters "Name=private-ip-address,Values=$ip" \
    --query "Reservations[*].Instances[*].InstanceId" \
    --output text)

  if [[ -z "$id" ]]; then
    echo "Can't find instance with IP $ip"
    return 1
  fi

  echo "Terminating $id ($ip)"
  aws ec2 terminate-instances \
    --profile "$profile" \
    --instance-ids "$id"
}

function watch-ec2-status() {
  if [[ $# -eq 0 ]]; then
    echo "instance name is required"
    exit 1
  fi
  NAME="${1}"
  PROFILE=${2:-"fusionauth-prod"}
  REGION=${3:-"us-east-1"}
  watch "aws ec2 describe-instances \
    --profile "${PROFILE}" \
    --region "${REGION}" \
    --filters 'Name=tag:Name,Values="${NAME}.*"' \
    --query 'Reservations[*].Instances[*].State.Name' \
    --output=text"
}

function watch-rds-status() {
  if [[ $# -eq 0 ]]; then
    echo "db instance name is required"
    exit 1
  fi
  NAME="${1}"
  PROFILE=${2:-"fusionauth-prod"}
  REGION=${3:-"us-east-1"}
  watch "aws rds describe-db-instances \
    --profile "${PROFILE}" \
    --region "${REGION}" \
    --db-instance-identifier "${NAME}" \
    --query 'DBInstances[*].DBInstanceStatus' \
    --output=text"
}

function watch-rds-snapshot-status() {
  if [[ $# -eq 0 ]]; then
    echo "snapshot name is required"
    exit 1
  fi
  NAME="${1}"
  PROFILE=${2:-"fusionauth-prod"}
  REGION=${3:-"us-east-1"}
  watch "aws rds describe-db-snapshots \
    --profile "${PROFILE}" \
    --region "${REGION}" \
    --db-snapshot-identifier "${NAME}" \
    --query 'DBSnapshots[*].PercentProgress' \
    --output=text"
}

function ecs-exec() {

  AWS_PROFILE="${1:-fusionauth-prod-admin}"
  REGION="${2:-us-east-1}"
  TASK_ARN=$(aws --profile $AWS_PROFILE --region $REGION ecs list-tasks --cluster edge-tls --query "taskArns[0]" --output text)

  echo "profile: $AWS_PROFILE"
  echo "region:  $REGION"
  echo "task:    $TASK_ARN"

  aws ecs execute-command --profile $AWS_PROFILE --region $REGION --cluster edge-tls --container caddy --interactive --task $TASK_ARN --command /bin/sh
}

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
