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
CSI_EC2_INSTANCE_ID=i-01d2ac28f993d85c6

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

EC2_CMD="aws --profile=${CSI_AWS_PROFILE} --region=${CSI_AWS_REGION} ec2"

case ${CMD} in
  -h|help)
    echo "Code Server IDE:"
    echo "================"
    echo ""
    echo "info -s|--status       Gather the current instance status"
    echo "info -i|--ip           Gather the current instance PublicIP"
    echo "info -t|--type         Gather the current instance Type"
    echo "info -g|--group        Gather the current instance security group id"
    echo "info -a|--all          Gather the full instance info as JSON"
    echo ""
    echo "start                  Start the instance"
    echo "start -t t2.micro      Set the EC2 type & start the instance"
    echo ""
    echo "stop                   Stop the instance"
    echo "stop -f|--force        Force stop the instance (good when the machine is stucked)"
    echo ""
    echo ""
    exit 0;
    ;;

  ##########################################################
  # GET INSTANCE INFO                                      #
  ##########################################################
  info)
    echo "Gathering info on EC2 instance: ${CSI_EC2_INSTANCE_ID}..."
    CLI_EC2_APPLY="${EC2_CMD} describe-instances"
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
      -t|--type)
        CLI_EC2_RESULT=$($CLI_EC2_APPLY 2>&1)
        echo ${CLI_EC2_RESULT} | jq '.Reservations[0].Instances[0].InstanceType'
        exit 0
        ;;
      -g|--group)
        CLI_EC2_RESULT=$($CLI_EC2_APPLY 2>&1)
        echo ${CLI_EC2_RESULT} | jq '.Reservations[0].Instances[0].NetworkInterfaces[0].Groups[0].GroupId'
        exit 0
        ;;
      # -r|--rules)
      #   # Create temp file and make sure it gets removed
      #   TMP_FILE=$(mktemp /tmp/code-server-ide.info.security-group-id.$(date +%s%N))
      #   exec 3>"$TMP_FILE"
      #   rm "$TMP_FILE"

      #   # Get security group id
      #   CLI_EC2_RESULT=$($CLI_EC2_APPLY 2>&1)
      #   echo $CLI_EC2_RESULT | jq '.Reservations[0].Instances[0].NetworkInterfaces[0].Groups[0].GroupId' > $TMP_FILE
      #   SECURITY_GROUP_ID=$(cat $TMP_FILE | cut -d "\"" -f 2)


      #   CLI_EC2_APPLY="${EC2_CMD} describe-security-groups"
      #   CLI_EC2_APPLY="${CLI_EC2_APPLY} --group-ids "${SECURITY_GROUP_ID}""
      #   RES=$(eval "$CLI_EC2_APPLY")
      #   echo $RES | jq '.SecurityGroups'
      #   # CLI_EC2_RESULT=$($CLI_EC2_APPLY 2>&1)
      #   # echo ${CLI_EC2_RESULT} | jq '.'
      #   exit 0
      #   ;;
      -a|--all)
        CLI_EC2_RESULT=$($CLI_EC2_APPLY 2>&1)
        echo ${CLI_EC2_RESULT} | jq '.Reservations[0].Instances[0]'
        exit 0
      ;;
    esac
    ;;

  ##########################################################
  # START INSTANCE                                         #
  ##########################################################
  start)
    echo "Starting EC2 instance: ${CSI_EC2_INSTANCE_ID}..."
    CLI_EC2_APPLY="${EC2_CMD} start-instances"
    CLI_EC2_APPLY="${CLI_EC2_APPLY} --instance-ids "${CSI_EC2_INSTANCE_ID}""

    case ${2:-"*"} in
      -t|--type)
        EC2_INSTANCE_TYPE=${3:-"t3.micro"}
        echo "Changing instance type to: ${EC2_INSTANCE_TYPE}..."
        CLI_EC2_APPLY1="${EC2_CMD} modify-instance-attribute"
        CLI_EC2_APPLY1="${CLI_EC2_APPLY1} --instance-id "${CSI_EC2_INSTANCE_ID}""
        CLI_EC2_APPLY1="${CLI_EC2_APPLY1} --attribute instanceType"
        CLI_EC2_APPLY1="${CLI_EC2_APPLY1} --value "${EC2_INSTANCE_TYPE}""
        $($CLI_EC2_APPLY1)
        echo "[ok]"
      ;;
    esac

    # Execute command
    CLI_EC2_RESULT=$($CLI_EC2_APPLY 2>&1)
    echo "[ok]"
    echo ""
    echo "${CLI_EC2_RESULT}"
    exit 0
    ;;

  ##########################################################
  # STOP INSTANCE                                          #
  ##########################################################
  stop)
    echo "Stopping EC2 instance: ${CSI_EC2_INSTANCE_ID}..."
    CLI_EC2_APPLY="${EC2_CMD} stop-instances"
    CLI_EC2_APPLY="${CLI_EC2_APPLY} --instance-ids "${CSI_EC2_INSTANCE_ID}""

    case ${2:-"*"} in
      -f|--force)
        CLI_EC2_APPLY="${CLI_EC2_APPLY} --force"
      ;;
    esac

    # Execute command
    CLI_EC2_RESULT=$($CLI_EC2_APPLY 2>&1)
    echo "[ok]"
    echo ""
    echo "${CLI_EC2_RESULT}"
    exit 0
    ;;
  *) echo "invalid option";;
esac
