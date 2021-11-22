output "id" {
  description   = "The Container Registry ID"
  value         = azurerm_container_registry.acr.id
}

output "acr_uri" {
  value         = "${azurerm_container_registry.acr.login_server}"
}

output "acr_user" {
  value         = "${azurerm_container_registry.acr.admin_username}"
}

output "acr_password" {
  value         = "${azurerm_container_registry.acr.admin_password}"
  sensitive     = true
}