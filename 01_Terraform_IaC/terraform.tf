terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform"
    storage_account_name = "hipsterteamfive"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }

  required_providers {
      azurerm = {
        source = "hashicorp/azurerm"
        version = "=2.46.0"
      }
  }
}