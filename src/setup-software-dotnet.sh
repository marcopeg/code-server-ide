#!/bin/bash
source "$(dirname "$0")/setup-profile.sh"

###
### Install .NET SDK & Framework
### https://docs.microsoft.com/en-us/dotnet/core/install/linux-ubuntu#2004-
###

echo "[$(date -u)] Install .NET 5.0 SDK & Framework for Ubuntu 20.x..." >> ${CODE_SERVER_LOGS}/setup.log

echo "[$(date -u)] Adding .NET package..." >> ${CODE_SERVER_LOGS}/setup.log
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb >> ${CODE_SERVER_LOGS}/setup.log 2>&1
dpkg -i packages-microsoft-prod.deb >> ${CODE_SERVER_LOGS}/setup.log 2>&1
rm -f packages-microsoft-prod.deb >> ${CODE_SERVER_LOGS}/setup.log 2>&1

echo "[$(date -u)] Adding .NET 5.0 SDK..." >> ${CODE_SERVER_LOGS}/setup.log
apt-get update >> ${CODE_SERVER_LOGS}/setup.log 2>&1
apt-get install -y apt-transport-https >> ${CODE_SERVER_LOGS}/setup.log 2>&1
apt-get update >> ${CODE_SERVER_LOGS}/setup.log 2>&1
apt-get install -y dotnet-sdk-2.1 >> ${CODE_SERVER_LOGS}/setup.log 2>&1
apt-get install -y dotnet-sdk-3.1 >> ${CODE_SERVER_LOGS}/setup.log 2>&1
apt-get install -y dotnet-sdk-5.0 >> ${CODE_SERVER_LOGS}/setup.log 2>&1

echo "[$(date -u)] Adding .NET 5.0 Runtime..." >> ${CODE_SERVER_LOGS}/setup.log
apt-get update >> ${CODE_SERVER_LOGS}/setup.log 2>&1
apt-get install -y apt-transport-https >> ${CODE_SERVER_LOGS}/setup.log 2>&1
apt-get update >> ${CODE_SERVER_LOGS}/setup.log 2>&1
apt-get install -y aspnetcore-runtime-5.0 >> ${CODE_SERVER_LOGS}/setup.log 2>&1

