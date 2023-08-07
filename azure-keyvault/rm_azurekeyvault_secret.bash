#!/usr/bin/env bash

# Use to remove azurekeyvault_secret.yml file

# How to execute
# sh /path/rm_azurekeyvault_secret.bash <ROLE NAME>

# Example: 
# sh ./azure-keyvault/rm_azurekeyvault_secret.bash sonar

#parameters
ROLE=$1

#paths
SONAR_PATH="roles/install_sonarqube/vars/azurekeyvault_secret.yml"
NEXUS_PATH="roles/install_nexus/vars/azurekeyvault_secret.yml"

case $ROLE in
    sonar)
    rm -rf $SONAR_PATH
    ;;

    nexus)
    rm -rf $NEXUS_PATH
    ;;
esac
