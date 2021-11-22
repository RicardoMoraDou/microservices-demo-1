resource "azurerm_kubernetes_cluster" "aks" {
  name                    = "aks-${var.suffix}-${var.environment}-${var.location}"
  location                = var.location
  resource_group_name     = var.rg_name
  dns_prefix              = var.dns_prefix

  default_node_pool {
    name                  = "default"
    node_count            = 1
    vm_size               = "Standard_D2_v2"
  }

  identity {
    type                  = "SystemAssigned"
  }

  tags = {
    Environment = var.environment
  }

  provisioner "local-exec" {
    # Load credentials to local environment so subsequent kubectl commands can be run
    command = <<EOS
      az aks get-credentials --resource-group ${azurerm_resource_group.default.name} --name ${self.name};
    
EOS

  }
}