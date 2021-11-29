# Deploy app from Github Actions

## Prerequisites

1.  Azure subscription

1.  Azure CLI

You need the next infrastructure in your Azure Portal subscription to apply this installation method [Infrastructure](./infra-guide.md) 

## Installation 

To install and run all the app with few steps follow the next to prepare the neccesary information to saved in Github Secrets

1. Fork the repository.

    ![alt text](img/fork_repository.png)

    ![alt text](img/repository_forked.png)

2. Create Secrets in GitHub

    ![alt text](img/secrets_2.png) 

    ![alt text](img/secrets.jpeg)  


| Service                | Language      | 
| ---------------------- | ------------- | 
| ACR_AKS_CREDENTIALS    | All the credencitial obtained from the command of the service principal|
| ACR_PASS               | CLIENT_SECRET| 
| ACR_SERVER             | URL OF THE ACR SERVER| 
| ACR_USER               | CLIENT_ID | 
| ARM_CLIENT_ID          | CLIENT_ID | 
| ARM_CLIENT_SECRET      | CLIENT_SECRET |
| ARM_SUBSCRIPTION_ID    | SUBSCRIPTION_ID  |         
| ARM_TENANT_ID          | TENANT_ID  |
| AZURE_PORTAL_PASSWORD  | PASSWORD AZURE PORTAL ACCOUNT |
| AZURE_PORTA_USER       | EMAIL AZURE PORTAL ACCOUNT| 
| GPG_PASS               | PRIVATE SSH KEY GENERATED FROM COMMAND ssh-keygen -t rsa -b 4096 ENCRYPTED |
| PROJECTIN_SP           | All the credencitial obtained from the command of the service principal |
| SSH_PRIVATE_KEY_VM     |PRIVATE SSH KEY GENERATED FROM COMMAND ssh-keygen -t rsa -b 4096|
| TF_VAR_SSH_KEY         |PRIVATE SSH KEY GENERATED FROM COMMAND ssh-keygen -t rsa -b 4096 FOR TERRAFORM DEPLOY|

3. Create a branch

````
git checkout -b <NAME_BRANCH>
````

4. Access to the next directory.

    ![alt text](img/access_github_workflows.png)

5. Modify the file 01_init_terraform_infra.yml into the directory.

- Add one space in the first line 

    ![alt text](img/edit_file.png)

- Make a commit to run the workflow

    ![alt text](img/edit_file_2.png)

6. Do a pull request

    ![alt text](img/pr_1.png)

- Select your repository

    ![alt text](img/pr_2.png)

- Select branch you are working on

    ![alt text](img/pr_3.png)
 
    ![alt text](img/pr_4.png)

    ![alt text](img/pr_5.png)

- Approve the merge request

    ![alt text](img/pr_6.png)

7. Workflow it's running

    ![alt text](img/workflow_run.png)


