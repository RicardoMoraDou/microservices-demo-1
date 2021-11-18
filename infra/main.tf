provider "azurerm" {
  features {}
//   skip_provider_registration = true
}

resource "azurerm_resource_group" "rg" {
  name                = "${var.prefix}-rg"
  location            = var.location
}

// module "vnet" {
//   source              = "./modules/vnet"
//   prefix              = var.prefix
//   location            = var.location
//   resource_group_name = data.azurerm_resource_group.rg.name    
// }

module "acr" {
  source              = "./modules/acr"
  prefix              = var.prefix
  location            = var.location
  rg_name             = azurerm_resource_group.rg.name
}

module "aks" {
  source              = "./modules/aks"
  prefix              = var.prefix
  location            = var.location
  rg_name             = azurerm_resource_group.rg.name
  acr_id              = module.acr.id
}

module "security" {
  source              = "./modules/security"
  location            = var.location
  rg_name             = azurerm_resource_group.rg.name
}

module "vnet" {
  source              = "./modules/vnet"
  prefix              = var.prefix
  location            = var.location
  rg_name             = azurerm_resource_group.rg.name
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [module.vnet.nic_id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                    = "myOsDisk"
    caching                 = "ReadWrite"
    storage_account_type    = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name  = "azurevm"
  admin_username = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username       = "azureuser"
    public_key     = module.security.public_key
  }

  tags = {
    environment = "Terraform Demo"
  }
}