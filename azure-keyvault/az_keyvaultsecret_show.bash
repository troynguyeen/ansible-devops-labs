#!/usr/bin/env bash

# Use to get the secret value from Azure Key Vault

# How to execute
# sh /path/az_keyvaultsecret_show.bash <ROLE NAME> <SECRET NAME>

# Example: 
# sh ./azure-keyvault/az_keyvaultsecret_show.bash sonar sonaruserpassword

#parameters
ROLE=$1
NAME=$2

#paths
SONAR_PATH="roles/install_sonarqube/vars/azurekeyvault_secret.yml"
NEXUS_PATH="roles/install_nexus/vars/azurekeyvault_secret.yml"

#colors
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"

case $ROLE in
    sonar)
    if ! grep -q $NAME $SONAR_PATH; then
        VALUE=$(az keyvault secret show --name $NAME --vault-name ansible-vault-s68 --query "value" | sed 's/"//g')
        if [ -n "$VALUE" ]; then
            echo "$NAME: $VALUE" >> $SONAR_PATH
            echo "$GREEN VARS: $NAME has set in path: /$SONAR_PATH $ENDCOLOR"
        fi
    else
        echo "$YELLOW VARS: $NAME was existed in path: /$SONAR_PATH $ENDCOLOR"
    fi
    ;;

    nexus)
    if ! grep -q $NAME $NEXUS_PATH; then
        VALUE=$(az keyvault secret show --name $NAME --vault-name ansible-vault-s68 --query "value" | sed 's/"//g')
        if [ -n "$VALUE" ]; then
            echo "$NAME: $VALUE" >> $NEXUS_PATH
            echo "$GREEN VARS: $NAME has set in path: /$NEXUS_PATH $ENDCOLOR"
        fi
    else
        echo "$YELLOW VARS: $NAME was existed in path: /$NEXUS_PATH $ENDCOLOR"
    fi
    ;;

    *)
    echo "$RED ROLE doesn't match with any Ansible roles $ENDCOLOR"
esac