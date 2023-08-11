# Get url from azure-config.yml
sshprivate_sas_url=$(cat ./azure-keyvault/azure-config.yml | grep sshprivate_sas_url | cut -d ' ' -f2)

# Download sshkey.pem to ansible directory
curl -fsSL "$sshprivate_sas_url" | sudo tee ./sshkey.pem > /dev/null

# Set permission for sshkey.pem
chmod 700 sshkey.pem