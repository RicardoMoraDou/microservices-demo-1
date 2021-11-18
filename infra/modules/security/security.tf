# Create an SSH key
resource "azurerm_ssh_public_key" "mysshkey" {
  location              = var.location
  name                  = var.name
  public_key            = file("~/.ssh/id_rsa.pub")
  resource_group_name   = var.rg_name
}