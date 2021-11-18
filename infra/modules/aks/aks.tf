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
}

resource "azurerm_role_assignment" "role_acrpull" {
  scope                             = var.acr_id
  role_definition_name              = "AcrPull"
  principal_id                      = azurerm_kubernetes_cluster.aks.kubelet_identity.0.object_id
  skip_service_principal_aad_check  = true
}