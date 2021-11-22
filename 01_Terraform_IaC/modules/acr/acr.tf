resource "azurerm_container_registry" "acr" {
  name                     = "${var.suffix}equipofive1"
  resource_group_name      = "${var.rg_name}"
  location                 = "${var.location}"
  sku                      = "Standard"
  admin_enabled            = false
  tags = {
    Environment = var.environment
  }
}