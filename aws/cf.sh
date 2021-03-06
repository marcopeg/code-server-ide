#!/bin/bash
# set -euo pipefail
CWD="$(dirname "$0")"

function help() {
  echo "============================"
  echo "CODE SERVER IDE"
  echo "aws cloud formation stack"
  echo "============================"

  # Show error message
  if [ ! -z "$1" ]; then
    echo ""
    echo "@@@ Error:"
    echo ${1}
  fi

  echo ""
  echo "Usage:"
  echo "./cf.sh up --pem foobar --cfId 93648858 --cfKey abcdefg"
  echo ""
  echo "Commands:"
  echo "up ................. it creates a new stack from scratch"
  echo "down ............... it destroys a stack permanently"
  echo "apply .............. it updates an existing stack with new parameters"
  echo ""
  echo "Mandatory Parameters:"
  echo "--dns .............. set the project's DNS name"
  echo ""
  echo "Optional Parameters:"
  echo "--aws-profile ...... set the AWS profile to use to authenticate while operating CloudFormation"
  echo "--aws-region ....... set the target region in AWS"
  echo "--aws-bucket ....... set the target S3 bucket where to store the stack templates"
  echo "--pem .............. set the pem key file to use to access the eC2 machine"
  echo "--cf-id ............ set the CloudFlare API Zone ID"
  echo "--cf-key ........... set the CloudFlare API Key"

  # Show error message
  if [ ! -z "$1" ]; then
    echo ""
    echo "@@@ Error:"
    echo "${1}"
  fi

  exit 0
}

function error() {
  echo ""
  echo "@@@ Error:"
  echo "${1##*( )}"
  echo ""
  exit -1
}

function syncS3() {
  echo "Syncing S3 templates..."
  CLI_SYNC_S3="aws --profile=${AWS_PROFILE} --region=${AWS_REGION}"
  CLI_SYNC_S3="${CLI_SYNC_S3} s3 sync"
  CLI_SYNC_S3="${CLI_SYNC_S3} --exclude '*'"
  CLI_SYNC_S3="${CLI_SYNC_S3} --include '*.yml'"
  CLI_SYNC_S3="${CLI_SYNC_S3} ${CWD}"
  CLI_SYNC_S3="${CLI_SYNC_S3} ${BUCKET_URL_S3}"
  $CLI_SYNC_S3
}

function describeStack() {
  CLI_CF_CHECK="aws --profile=${AWS_PROFILE} --region=${AWS_REGION}"
  CLI_CF_CHECK="${CLI_CF_CHECK} cloudformation describe-stacks"
  CLI_CF_CHECK="${CLI_CF_CHECK} --stack-name "box-${STACK_NAME}""
  CLI_CF_CHECK=$($CLI_CF_CHECK 2>&1)
  echo ${CLI_CF_CHECK}
}

function getStackAction() {
  getStackAction_result=$(describeStack)
  if jq -e . >/dev/null 2>&1 <<<"${getStackAction_result}"; then
    echo "update"
  else
    echo "create"
  fi
}

function applyStack() {
  CLI_CF_APPLY="aws --profile=${AWS_PROFILE} --region=${AWS_REGION}"
  CLI_CF_APPLY="${CLI_CF_APPLY} cloudformation ${1}-stack"
  CLI_CF_APPLY="${CLI_CF_APPLY} --stack-name "box-${STACK_NAME}""
  CLI_CF_APPLY="${CLI_CF_APPLY} --template-url "${BUCKET_URL_HTTP}/master.yml""
  CLI_CF_APPLY="${CLI_CF_APPLY} --capabilities  ${STACK_CAPABILITIES}"
  CLI_CF_APPLY="${CLI_CF_APPLY} --parameters ${STACK_PARAMS}"

  # Execute command and get resulting status
  CLI_CF_RESULT=$($CLI_CF_APPLY 2>&1)
  CLI_CF_STATUS=$?

  # Catch no-updates needed
  if [ $CLI_CF_STATUS -ne 0 ] ; then
    if [[ $CLI_CF_RESULT == *"ValidationError"* && $CLI_CF_RESULT == *"No updates"* ]] ; then
      echo -e "\nFinished ${1} - no updates to be performed"
      exit 0
    else
      error "${CLI_CF_RESULT}"
    fi
  else
    if ! jq -e . >/dev/null 2>&1 <<<"${CLI_CF_RESULT}"; then
      error "${CLI_CF_RESULT}"
    fi
  fi
}

function getAmiId() {
  # https://discourse.ubuntu.com/t/finding-ubuntu-images-with-the-aws-ssm-parameter-store/15507
  AWS_EC2_AMI_ID=$(aws --region eu-west-1 --profile default ssm get-parameters --names \
        /aws/service/canonical/ubuntu/server/focal/stable/current/amd64/hvm/ebs-gp2/ami-id \
    --query 'Parameters[0].[Value]' --output text)
}

function getInstanceId() {
  CLI_CF_GET_EC2_ID="aws --profile=${AWS_PROFILE} --region=${AWS_REGION}"
  CLI_CF_GET_EC2_ID="${CLI_CF_GET_EC2_ID} cloudformation describe-stacks"
  CLI_CF_GET_EC2_ID="${CLI_CF_GET_EC2_ID} --stack-name "box-${STACK_NAME}""

  # Execute command and get resulting status
  CLI_CF_RESULT=$($CLI_CF_GET_EC2_ID 2>&1)
  CLI_CF_STATUS=$?

  # Use jq to extract the InstanceId from the stack's output
  # https://github.com/stedolan/jq/wiki/Cookbook#filter-objects-based-on-the-contents-of-a-key
  JQ_OUTPUTS=$(jq -r '.Stacks[0].Outputs' <<<"${CLI_CF_RESULT}")
  JQ_INSTANCE_OBJ=$(jq -r '.[] | select(.OutputKey | contains("InstanceId"))' <<<"${JQ_OUTPUTS}")
  jq -r '.OutputValue' <<<"${JQ_INSTANCE_OBJ}"
}

function createStack() {
  # Validate required parameters
  [ -z ${PAR_PEM+x} ] && help "Required parameter: --pem"
  [ -z ${PAR_EMAIL+x} ] && help "Required parameter: --email"
  [ -z ${PAR_CF_ZONE_ID+x} ] && help "Required parameter: --cf-zone-id"
  [ -z ${PAR_CF_API_KEY+x} ] && help "Required parameter: --cf-api-key"
  [ -z ${PAR_SG_API_KEY+x} ] && help "Required parameter: --sg-api-key"

  echo "Creating stack: ${STACK_NAME}..."
  getAmiId
  STACK_PARAMS="${STACK_PARAMS} ParameterKey=EC2ImageId,ParameterValue=${AWS_EC2_AMI_ID}"
  STACK_PARAMS="${STACK_PARAMS} ParameterKey=EC2InstanceType,ParameterValue=${PAR_EC2_TYPE}"
  STACK_PARAMS="${STACK_PARAMS} ParameterKey=EC2KeyPairName,ParameterValue=${PAR_PEM}"
  STACK_PARAMS="${STACK_PARAMS} ParameterKey=CSDns,ParameterValue=${PAR_DNS}"
  STACK_PARAMS="${STACK_PARAMS} ParameterKey=CSEmail,ParameterValue=${PAR_EMAIL}"
  STACK_PARAMS="${STACK_PARAMS} ParameterKey=CFZoneId,ParameterValue=${PAR_CF_ZONE_ID}"
  STACK_PARAMS="${STACK_PARAMS} ParameterKey=CFApiKey,ParameterValue=${PAR_CF_API_KEY}"
  STACK_PARAMS="${STACK_PARAMS} ParameterKey=SGApiKey,ParameterValue=${PAR_SG_API_KEY}"

  echo $STACK_PARAMS

  #applyStack "create"

  # echo "Waiting for stack to be created ..."
  # aws cloudformation wait stack-create-complete --profile=${AWS_PROFILE} --region=${AWS_REGION} 2>&1

  #echo ${CLI_CF_RESULT}
}

function updateStack() {
  echo "Updating stack: ${STACK_NAME}..."

  STACK_PARAMS="${STACK_PARAMS} ParameterKey=EC2ImageId,UsePreviousValue=true"
  STACK_PARAMS="${STACK_PARAMS} ParameterKey=EC2KeyPairName,UsePreviousValue=true"

  if [ -z ${PAR_PEM+x} ]; then
    STACK_PARAMS="${STACK_PARAMS} ParameterKey=EC2InstanceType,UsePreviousValue=true"
  else
    STACK_PARAMS="${STACK_PARAMS} ParameterKey=EC2InstanceType,ParameterValue=${PAR_EC2_TYPE}"
  fi
  
  if [ -z ${PAR_CF_ZONE_ID+x} ]; then
    STACK_PARAMS="${STACK_PARAMS} ParameterKey=CFZoneId,UsePreviousValue=true"
  else
    STACK_PARAMS="${STACK_PARAMS} ParameterKey=CFZoneId,ParameterValue=${PAR_CF_ZONE_ID}"
  fi
  
  if [ -z ${PAR_CF_API_KEY+x} ]; then
    STACK_PARAMS="${STACK_PARAMS} ParameterKey=CFApiKey,UsePreviousValue=true"
  else
    STACK_PARAMS="${STACK_PARAMS} ParameterKey=CFApiKey,ParameterValue=${PAR_CF_API_KEY}"
  fi
  
  if [ -z ${PAR_SG_API_KEY+x} ]; then
    STACK_PARAMS="${STACK_PARAMS} ParameterKey=SGApiKey,UsePreviousValue=true"
  else
    STACK_PARAMS="${STACK_PARAMS} ParameterKey=SGApiKey,ParameterValue=${PAR_SG_API_KEY}"
  fi

  if [ -z ${PAR_DNS+x} ]; then
    STACK_PARAMS="${STACK_PARAMS} ParameterKey=CSDns,UsePreviousValue=true"
  else
    STACK_PARAMS="${STACK_PARAMS} ParameterKey=CSDns,ParameterValue=${PAR_DNS}"
  fi

  if [ -z ${PAR_EMAIL+x} ]; then
    STACK_PARAMS="${STACK_PARAMS} ParameterKey=CSEmail,UsePreviousValue=true"
  else
    STACK_PARAMS="${STACK_PARAMS} ParameterKey=CSEmail,ParameterValue=${PAR_EMAIL}"
  fi
  
  applyStack "update"

  # echo "Waiting for stack to be updated ..."
  # aws cloudformation wait stack-update-complete --profile=${AWS_PROFILE} --region=${AWS_REGION} 2>&1

  echo ${CLI_CF_RESULT}
}

function deleteStack() {
  echo "Deleting stack: ${STACK_NAME}..."

  echo "Figuring out current stack state..."
  upsertStack_actionStr=$(getStackAction)
  if [ "${upsertStack_actionStr}" == "create" ]; then
    echo -e "The stack doesn't exists - nothing to delete here"
    exit 0
  fi

  CLI_CF_DELETE="aws --profile=${AWS_PROFILE} --region=${AWS_REGION}"
  CLI_CF_DELETE="${CLI_CF_DELETE} cloudformation delete-stack"
  CLI_CF_DELETE="${CLI_CF_DELETE} --stack-name "box-${STACK_NAME}""

  # Execute command and get resulting status
  CLI_CF_RESULT=$($CLI_CF_DELETE 2>&1)
  CLI_CF_STATUS=$?

  # Catch no-updates needed
  if [ $CLI_CF_STATUS -ne 0 ] ; then
    error "${CLI_CF_RESULT:-"Could not delete the stack"}"
  else
    echo -e "Stack successfully deleted"
  fi
}

function upsertStack() {
  [ -z ${PAR_DNS+x} ] && help "Required parameter: --dns"
  echo "Upserting stack: ${STACK_NAME}"
  syncS3
  
  echo "Figuring out current stack state..."
  upsertStack_actionStr=$(getStackAction)
  if [ "${upsertStack_actionStr}" == "create" ]; then
    createStack
  else
    updateStack
  fi
}

function applyEc2() {
  echo "Gathering instanceId from the stack..."
  EC2_INSTANCE_ID=$(getInstanceId)

  echo "${1}ing EC2 instance: ${EC2_INSTANCE_ID}..."
  CLI_EC2_APPLY="aws --profile=${AWS_PROFILE} --region=${AWS_REGION}"
  CLI_EC2_APPLY="${CLI_EC2_APPLY} ec2 ${1}-instances"
  CLI_EC2_APPLY="${CLI_EC2_APPLY} --instance-ids "${EC2_INSTANCE_ID}""

  # Execute command and get resulting status
  CLI_EC2_RESULT=$($CLI_EC2_APPLY 2>&1)
  CLI_EC2_STATUS=$?

  
}

function startInstance() {
  applyEc2 "start"
  echo "result: ${CLI_EC2_RESULT}"
}

function stopInstance() {
  applyEc2 "stop"
  echo "result: ${CLI_EC2_RESULT}"
}

# Default variables
AWS_REGION="eu-west-1"
AWS_PROFILE="default"
AWS_BUCKET="marcopeg-code-server-ide"
STACK_CAPABILITIES="CAPABILITY_IAM CAPABILITY_NAMED_IAM"
STACK_PARAMS=""

# Show help if no params were given
#CHKP=${1:-} ; [ -z ${CHKP} ] && help

while [ "$#" -ne 0 ] ; do
  case "$1" in
    up|down|stop|start)
      PAR_CMD="$1"
      shift
      ;;
    -h|--help)
      help
      shift
      ;;
    --dns)
      PAR_DNS="${2}"
      shift 2
      ;;
    --pem)
      PAR_PEM="${2}"
      shift 2
      ;;
    --email)
      PAR_EMAIL=${2}
      shift 2
      ;;
    --cf-zone-id)
      PAR_CF_ZONE_ID=${2}
      shift 2
      ;;
    --cf-api-key)
      PAR_CF_API_KEY=${2}
      shift 2
      ;;
    --sg-api-key)
      PAR_SG_API_KEY=${2}
      shift 2
      ;;
    --ec2-type)
      PAR_EC2_TYPE=${2}
      shift 2
      ;;
    --aws-region)
      AWS_REGION="${2}"
      shift 2
      ;;
    --aws-profile)
      AWS_PROFILE="${2}"
      shift 2
      ;;
    --aws-bucket)
      AWS_BUCKET="${2}"
      shift 2
      ;;
    *)
      help
      shift
      ;;
  esac
done

# Check for a command and required options to be placed:
[ -z ${PAR_CMD+x} ] && help "Missing command: up / down"
[ -z ${PAR_DNS+x} ] && help "Required parameter: --dns"

# Calculate stack name from DNS entry:
STACK_NAME=$(echo "${PAR_DNS//./ }" | awk '{n=split($0,A);S=A[n];{for(i=n-1;i>0;i--)S=S" "A[i]}}END{print S}')
STACK_NAME=${STACK_NAME// /-}

# Calculate S3 template's url:
BUCKET_URL_S3="s3://${AWS_BUCKET}/${STACK_NAME}"
BUCKET_URL_HTTP="https://${AWS_BUCKET}.s3-${AWS_REGION}.amazonaws.com/${STACK_NAME}"

# Fill stack parameters
STACK_PARAMS="${STACK_PARAMS} ParameterKey=S3TemplateRoot,ParameterValue=${BUCKET_URL_HTTP}"

case ${PAR_CMD} in
  up)
    upsertStack
    ;;
  down)
    deleteStack
    ;;
  start)
    startInstance
    ;;
  stop)
    stopInstance
    ;;
  *)
    help 
    ;;
esac






# echo "---------------------------"
# echo "name: ${STACK_NAME}"
# echo "url ${BUCKET_URL_S3}"
# echo "url ${BUCKET_URL_HTTP}"
# echo "---------------------------"

# Get the default VPC ID
# CLI_AWS_VPC="aws --profile=${AWS_PROFILE} --region=${AWS_REGION}"
# CLI_AWS_VPC="${CLI_AWS_VPC} ec2 describe-vpcs"
# CLI_AWS_VPC="${CLI_AWS_VPC} --filters Name=isDefault,Values=true"
# CLI_AWS_VPC="${CLI_AWS_VPC} --query "Vpcs[*].VpcId""
# CLI_AWS_VPC="${CLI_AWS_VPC} --output text"
# echo ${CLI_AWS_VPC}
# VPC_ID=$($CLI_AWS_VPC)






# CLI_CF_UPSERT="aws --profile=${AWS_PROFILE} --region=${AWS_REGION}"
# CLI_CF_UPSERT="${CLI_CF_UPSERT} cloudformation ${STACK_ACTION}-stack"
# CLI_CF_UPSERT="${CLI_CF_UPSERT} --stack-name "box-${STACK_NAME}""
# CLI_CF_UPSERT="${CLI_CF_UPSERT} --template-url "${BUCKET_URL_HTTP}/master.yml""
# CLI_CF_UPSERT="${CLI_CF_UPSERT} --capabilities  ${STACK_CAPABILITIES}"
# # CLI_CF_UPSERT="${CLI_CF_UPSERT} --parameters ${STACK_PARAMS}"
# echo "Updating stack..."
# $CLI_CF_UPSERT

# Create the command to launch
# CLI="aws s3 ls s3://${AWS_BUCKET} --profile ${AWS_PROFILE} --region ${AWS_REGION}"
# echo ${CLI}
# $CLI
