# Provisioning Guide

## Prerequisites 

- [Create an Azure Account](https://azure.microsoft.com/)
- [Install Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Install Terraform CLI](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- [Install Ansible ](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- [Install Kubectl ](https://v1-18.docs.kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Install Helm ](https://helm.sh/docs/intro/install/)


### Set up your Azure credentials

Use `az login` to login to your azure account through the cli, a new window will pop up in your browser, enter your credentials and comeback to the command line. Note: if you are in an environment without a browser, an special code and URL will be displayed and you´ll have to open that link in a different device where a browser is available.

```
az login
```

If donce correctly an output like this will be displayed:

```
{
    "cloudName": "AzureCloud",
    "id": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
    "isDefault": true,
    "name": "Your-subscription-name",
    "state": "Enabled",
    "tenantId": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
    "user": {
      "name": "your.email@your.domain.com",
      "type": "user"
    }
  }
```

We'll need the id field later in this guide, so save it. (If you have multiple subscriptions in your account be sure to set you desired subscription with `az account set --subscription <subscription-id>`).



### Create the remote storage for your Terraform state

To have a better track of the deployed resources we need to use a remote terraform state, by default the state is local and is storaged at the root of your terraform project, this is problematic when you are working with a team because there´s no way for your team to know what you have deployed or destroyed. We'll use an azure blob storage to save our terraform state file.

Create an azure resource group for the blob storage account that you're gonna deploy.

```
az group create --name $RESOURCE_GROUP_NAME --location eastus
```

Create the storage account.

```
az storage account create --resource-group rg-terraform --name hipsterteamfive --sku Standard_LRS --encryption-services blob
```

Get the storage account key, it'll be used in the next command to create an storage container inside it.

````
ACCOUNT_KEY=$(az storage account keys list --resource-group rg-terraform --account-name hipsterteamfive --query '[0].value' -o tsv)
````

Create the storage container.

```
az storage container create --name tfstate --account-name hipsterteamfive --account-key $ACCOUNT_KEY
```



### Create a Service Principal

In order to manage azure resources with terraform we need to provide authetication credentials for the azurerm provider. We do this with a service principal and exporting the credentials as environment variables. 

To create a service principal use the following command, replace <SUBSCRIPTION_ID> with the `id` field from the output of the first command `az login`:

```
az ad sp create-for-rbac -n "<NAME_THIS_SP>" --role Contributor --scopes /subscriptions/<SUBSCRIPTION_ID>
```

You should get and output like this:

```
Creating a role assignment under the scope of "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
  Retrying role assignment creation: 1/36
  Retrying role assignment creation: 2/36
{
  "appId": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
  "displayName": "azure-cli-XXXX-XX-XX-XX-XX-XX",
  "name": "http://azure-cli-XXXX-XX-XX-XX-XX-XX",
  "password": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
  "tenant": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
}
```

Now you have to set the next env variables:

- ARM_CLIENT_ID
- ARM_CLIENT_SECRET
- ARM_TENANT_ID

You can get this variables from the output of the previous command, like this:

```
ARM_CLIENT_ID="<appId>"
ARM_CLIENT_SECRET="<password>"
ARM_TENANT_ID="<tenant>"
```



### Create an ssh key pair

To be able to login into the vault virtual machine you need an ssh key pair, you can create one with the next command:

```
ssh-keygen -t rsa -b 4096
```

Then, set the content of the public key as a terraform env variable, like this:

```
TF_VAR_SSH_KEY="ssh-rsa XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
```

That way you and configuration management tools can login with the private key as the admin user: azureuser.



### Provision the infrastructure with Terraform and Github Actions

**For this step you need to set up and run your Github Actions pipeline.**

*If you want to try to just provision the infrastructure alone, you'll have to export the previous env variables and run the following commands:* `terraform init`, `terraform apply`.

 



