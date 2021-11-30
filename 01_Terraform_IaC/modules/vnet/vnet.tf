# Create virtual network
resource "azurerm_virtual_network" "vnet" {
    name                    = "vnet-vault-${var.suffix}-${var.environment}-${var.location}"
    address_space           = [var.addr_space]
    location                = var.location
    resource_group_name     = var.rg_name

    tags = {
        environment = var.environment
    }
}

# Create subnet
resource "azurerm_subnet" "subnet_vault" {
    name                    = "snet-vault-${var.suffix}"
    resource_group_name     = var.rg_name
    virtual_network_name    = azurerm_virtual_network.vnet.name
    address_prefixes        = [var.addr_prefixes_vault]
}

# Create public IPs
resource "azurerm_public_ip" "ip_vault" {
    name                    = "ip-vault-${var.suffix}"
    location                = var.location
    resource_group_name     = var.rg_name
    allocation_method       = "Dynamic"
    ip_version              = "IPv4"
    domain_name_label       = "vault-team-five"

    tags = {
        environment = var.environment
    }
}

# Create Network Security Group
resource "azurerm_network_security_group" "nsg" {
    name                    = "nsg-vault-${var.suffix}-${var.environment}-${var.location}"
    location                = var.location
    resource_group_name     = var.rg_name

    tags = {
        environment = var.environment
    }
}

# Crate inbound rule for ssh
resource "azurerm_network_security_rule" "nsr_ssh" {
  name                        = "SSH"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# Crate inbound rule for vault
resource "azurerm_network_security_rule" "nsr_vault" {
  name                        = "Vault"
  priority                    = 1011
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8200"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# Crate inbound rule for test
resource "azurerm_network_security_rule" "nsr_test" {
  name                        = "Test"
  priority                    = 1021
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "7357"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}


# Create network interface
resource "azurerm_network_interface" "nic_vault" {
    name                      = "nic-vault-${var.suffix}-${var.environment}-${var.location}"
    location                  = var.location
    resource_group_name       = var.rg_name

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = azurerm_subnet.subnet_vault.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.ip_vault.id
    }

    tags = {
        environment = var.environment
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "vault_nic_nsg_association" {
    
    network_interface_id      = azurerm_network_interface.nic_vault.id
    network_security_group_id = azurerm_network_security_group.nsg.id
}