#!/bin/bash
# set -euo pipefail

#####################################################
# CONFIGURATION                                     #
#####################################################
#                                                   #
# Please create the `~/.csirc` file in your home    #
# folder and set up the following information:      #
#                                                   #
# > CSI_AWS_PROFILE="default"                       #
# > CSI_AWS_REGION="eu-west-1"                      #
# > CSI_EC2_INSTANCE_ID="i-xxxx"                    #
#                                                   #
#####################################################

source ~/.csirc


#####################################################
# CREATE AN ALIAS FOR YOUR USER                     #
#####################################################
#                                                   #
# Edit any of the following files:                  #
# - ~/.profile                                      #
# - ~/.bashrc                                       #
# - ~/.zprofile                                     #
# - ~/.zshrc                                        #
#                                                   #
# Add the following line:                           #
# > alias csi="~/code-server-ide/src/client_cli.sh" #
#                                                   #
# NOTE: Customize the url to point to the proper    #
#       path where you have cloned the project.     #
#                                                   #
# Reload the configuration for your terminal:       #
# > source ~/.profile                               #
#                                                   #
#####################################################



#####################################################
# DO NOT EDIT BELOW THIS POINT                      #
#####################################################

# Gather Variables:
CWD="$(dirname "$0")"
CMD=${1:-"info"}

case ${CMD} in
  -h|help)
    echo "Code Server IDE:"
    echo "================"
    echo ""
    echo "info -s|--status       Gather the current instance status"
    echo "info -i|--ip           Gather the current instance PublicIP"
    echo "info -a|--all          Gather the full instance info as JSON"
    echo ""
    echo "start                  Start the instance"
    echo "stop                   Stop the instance"
    echo "stop -f|--force        Force stop the instance (good when the machine is stucked)"
    echo ""
    echo ""
    exit 0;
    ;;
  info)
    echo "Gathering info on EC2 instance: ${CSI_EC2_INSTANCE_ID}..."
    CLI_EC2_APPLY="aws --profile=${CSI_AWS_PROFILE} --region=${CSI_AWS_REGION}"
    CLI_EC2_APPLY="${CLI_EC2_APPLY} ec2 describe-instances"
    CLI_EC2_APPLY="${CLI_EC2_APPLY} --instance-ids "${CSI_EC2_INSTANCE_ID}""

    case ${2:-"-s"} in
      -s|--status)
        CLI_EC2_RESULT=$($CLI_EC2_APPLY 2>&1)
        echo ${CLI_EC2_RESULT} | jq '.Reservations[0].Instances[0].State.Name'
        exit 0
        ;;
      -i|--ip)
        CLI_EC2_RESULT=$($CLI_EC2_APPLY 2>&1)
        echo ${CLI_EC2_RESULT} | jq '.Reservations[0].Instances[0].PublicIpAddress'
        exit 0
        ;;
      -a|--all)
        CLI_EC2_RESULT=$($CLI_EC2_APPLY 2>&1)
        echo ${CLI_EC2_RESULT} | jq '.Reservations[0].Instances[0]'
        exit 0
      ;;
    esac
    ;;
  start|stop)
    echo "${CMD}ing EC2 instance: ${CSI_EC2_INSTANCE_ID}..."
    CLI_EC2_APPLY="aws --profile=${CSI_AWS_PROFILE} --region=${CSI_AWS_REGION}"
    CLI_EC2_APPLY="${CLI_EC2_APPLY} ec2 ${CMD}-instances"
    CLI_EC2_APPLY="${CLI_EC2_APPLY} --instance-ids "${CSI_EC2_INSTANCE_ID}""

    if [ ${2:-""} == "-f" ]; then
      CLI_EC2_APPLY="${CLI_EC2_APPLY} --force"
    fi
    ;;
  *) echo "invalid option";;
esac

# Execute command and get resulting status
CLI_EC2_RESULT=$($CLI_EC2_APPLY 2>&1)
CLI_EC2_STATUS=$?

echo "result: ${CLI_EC2_RESULT}"
echo "status: ${CLI_ECCLI_EC2_STATUS2_RESULT}"