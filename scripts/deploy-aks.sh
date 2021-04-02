# Create a resource group
echo "Creating resource group '$RG_NAME' in region '$LOCATION'."
az group create --name $RG_NAME --location $LOCATION --output none

#Create ACR instance
echo "Creating ACR '$ACR_NAME' in resource group '$RG_NAME'."
az acr create --name $ACR_NAME --resource-group $RG_NAME --sku basic --output none

# Create an AKS cluster with ACR
echo "Creating AKS cluster '$AKS_NAME' in resource group '$RG_NAME'."
az aks create --name $AKS_NAME --resource-group $RG_NAME \
    --node-count $AKS_NODE_COUNT \
    --attach-acr $ACR_NAME \
    --generate-ssh-keys --output none

# Retrieve kubectl credentials from the cluster
az aks get-credentials --name $AKS_NAME --resource-group $RG_NAME \
    --overwrite-existing

# Setup a Service Principal for GitHub Actions to connect to ACR
ACR_REGISTRY_ID=$(az acr show --name $ACR_NAME --resource-group $RG_NAME --query id --output tsv)

SP_PASSWD=$(az ad sp create-for-rbac --name http://$SERVICE_PRINCIPAL_NAME --scopes $ACR_REGISTRY_ID --role acrpush --query password --output tsv)
SP_APP_ID=$(az ad sp show --id http://$SERVICE_PRINCIPAL_NAME --query appId --output tsv)

# Service Principal Credentials
echo "Service principal ID: $SP_APP_ID"
echo "Service principal password: $SP_PASSWD"
