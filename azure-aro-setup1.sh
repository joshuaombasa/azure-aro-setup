# Login to Azure
az login

# Create Resource Group
az group create --name aro-resource-group --location eastus

# Create Virtual Network and Subnets
az network vnet create --resource-group aro-resource-group --name aro-vnet --address-prefixes 10.0.0.0/9 --subnet-name master-subnet --subnet-prefix 10.0.0.0/24
az network vnet subnet create --resource-group aro-resource-group --vnet-name aro-vnet --name worker-subnet --address-prefixes 10.0.1.0/24

# Get Subnet IDs
az network vnet subnet show --resource-group aro-resource-group --vnet-name aro-vnet --name master-subnet --query id --output tsv
az network vnet subnet show --resource-group aro-resource-group --vnet-name aro-vnet --name worker-subnet --query id --output tsv

# Register RedHat OpenShift Provider
az provider register --namespace Microsoft.RedHatOpenShift

# Create ARO Cluster
az aro create --resource-group aro-resource-group --name aro-cluster --vnet aro-vnet --master-subnet-id <master-subnet-id> --worker-subnet-id <worker-subnet-id> --apiserver-visibility Public --ingress-visibility Public

# Get Cluster Credentials
az aro list-credentials --name aro-cluster --resource-group aro-resource-group
