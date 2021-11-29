# Deploy app from local machine

## Prerequisites

1.  Azure subscription

1.  Azure CLI

1.  Terraform

1.  Ansible

1.  Kubectl

1.  Helm

If you don't have all the requirements visit the next documentation to insall all the packages you need: [Provision the infrastructure](./infra-guide.md)

## Installation 

1. Clone this repository

```
git clone https://github.com/RicardoMoraDou/microservices-demo-1.git
cd microservices-demo-1.git
```

2. Set your Azure credentials

```
az login
az account set --subscription "<SUBSCRIPTION_ID>"
```

3. Create service principal

```
az ad sp create-for-rbac --name "servicePrin_Name" --role contributor \
    --scopes /subscriptions/{subscription-id} \
    --sdk-auth
```

4. From the output of previous command, export the service principal credentials

```
export ARM_SUBSCRIPTION_ID=<SUBSCRIPTION_ID>
export ARM_CLIENT_ID=<appID>
export ARM_CLIENT_SECRET=<password>
export ARM_TENANT_ID=<tenant>
```

5. Create a resource group

```
az group create -l <REGION> -n <RESOURCE_GROUP_NAME>
```

6. Create a storage container for terraform state

```
az storage account create --resource-group <RESOURCE_GROUP_NAME> --name <STORAGE_ACCOUNT_NAME> --sku Standard_LRS --encryption-services blob

ACCOUNT_KEY=$(az storage account keys list --resource-group <RESOURCE_GROUP_NAME> --account-name <STORAGE_ACCOUNT_NAME> --query '[0].value' -o tsv)

az storage container create --name <CONTAINER_NAME> --account-name <STORAGE_ACCOUNT_NAME> --account-key $ACCOUNT_KEY
```

7. Provision the infrastructure

```
cd <TERRAFORM DIRECTORY PATH>

terraform init

terraform apply
```

8. Create Container Registry and Login to ACR

```
az acr create --resource-group <RESOURCE_GROUP_NAME> --name <CONTAINER_NAME> --sku Basic --admin-enabled true

az acr login --name <REGISTRY-NAME>
```

9. Create Container Registry and Login to ACR

```
az acr create --resource-group <RESOURCE_GROUP_NAME> --name <CONTAINER_NAME> --sku Basic --admin-enabled true

az acr login --name <REGISTRY-NAME>
```

10. Build each Microservice from the Directory SCR 

(Note: For this step we recommended to create a bash script to build all the images at the same time)

```
az acr build  --registry <CONTAINER_NAME> --image <NAME>:latest <PATH_DOCKERFILE_MICROSERVICE>
```

11. Install the app into Kubernetes

```
az aks update -n <AKS_NAME> -g <RESOURCE_GROUP_NAME> --attach-acr <LOGIN_SERVER>
```

12. Install the app into Kubernetes

```
helm install <NAME> ./<HELM_CHART_PATH>
```
13. Create a private SSH key

```
ssh-keygen -t rsa
```

14. Install Vault into VM with ansible

```
ansible-playbook playbook.yaml -i inventory -u azureuser  --private-key id_rsa
```


