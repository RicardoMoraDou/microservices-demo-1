resource "azurerm_container_registry" "acr" {
  name                     = "${var.suffix}equipofive"
  resource_group_name      = "${var.rg_name}"
  location                 = "${var.location}"
  sku                      = "Standard"
  admin_enabled            = false
  tags = {
    Environment = var.environment
  }
}