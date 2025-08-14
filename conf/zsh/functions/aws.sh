#!/usr/bin/env bash

function ec2-terminate-by-ip() {
  local profile="$1"
  local region="$2"
  local ip="$3"
  local id=""

  if [[ -z "$profile" || -z "$region" || -z "$ip" ]]; then
    echo "Usage: $0 [aws-profile] [aws-region] [ip-addr]"
    return 1
  fi

  id=$(aws ec2 describe-instances --profile "$profile" --region "$region" \
    --filters "Name=private-ip-address,Values=$ip" \
    --query "Reservations[*].Instances[*].InstanceId" \
    --output text)

  if [[ -z "$id" ]]; then
    echo "Can't find instance with IP $ip"
    return 1
  fi

  echo "Terminating $id ($ip)"
  aws ec2 terminate-instances --profile "$profile" --region "$region" --instance-ids "$id"
}


function watch-ec2-status() {
  local profile="$1"
  local region="$2"
  local name="$3"

  if [[ -z "$profile" || -z "$region" ]]; then
    echo "Usage: $0 [aws-profile] [aws-region] [instance-name]"
    return 1
  fi

  watch "aws ec2 describe-instances --profile $profile --region $region \
    --filters 'Name=tag:Name,Values=$name' \
    --query 'Reservations[*].Instances[*].State.Name' \
    --output=text"
}


function watch-rds-status() {
  local profile="$1"
  local region="$2"
  local name="$3"

  if [[ -z "$profile" || -z "$region" ]]; then
    echo "Usage: $0 [aws-profile] [aws-region] [instance-name]"
    return 1
  fi

  watch "aws rds describe-db-instances --profile $profile --region $region \
    --db-instance-identifier ${NAME} \
    --query 'DBInstances[*].DBInstanceStatus' \
    --output=text"
}


function watch-rds-snapshot-status() {
  local profile="$1"
  local region="$2"
  local name="$3"

  if [[ -z "$profile" || -z "$region" ]]; then
    echo "Usage: $0 [aws-profile] [aws-region] [snapshot-name]"
    return 1
  fi

  watch "aws rds describe-db-instances --profile $profile --region $region \
    --db-snapshot-identifier ${NAME} \
    --query 'DBSnapshots[*].PercentProgress' \
    --output=text"
}


function ecs-exec() {
  local profile="${1:-fusionauth-prod-admin}"
  local region="${2:-us-east-1}"
  local task_arn

  if [[ -z "$profile" || -z "$region" ]]; then
    echo "Usage: $0 [aws-profile] [aws-region]"
    return 1
  fi

  task_arn=$(aws --profile "$profile" --region "$region" ecs list-tasks --cluster edge-tls --query "taskArns[0]" --output text)

  echo "profile: $profile"
  echo "region:  $region"
  echo "task:    $task_arn"

  aws ecs execute-command --profile "$profile" --region "$region" --cluster edge-tls --container caddy --interactive --task "$task_arn" --command /bin/sh
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
