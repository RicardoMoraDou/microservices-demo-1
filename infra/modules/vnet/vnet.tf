# Create virtual network
resource "azurerm_virtual_network" "vnet" {
    name                = "${var.prefix}-vn"
    address_space       = [var.addr_space]
    location            = var.location
    resource_group_name = var.rg_name

    tags = {
        environment = "Dev"
    }
}

# Create subnet
resource "azurerm_subnet" "subnet" {
    name                 = "${var.prefix}-sn1"
    resource_group_name  = var.rg_name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes       = [var.addr_prefixes]
}

# Create public IPs
resource "azurerm_public_ip" "ip" {
    name                         = var.ip_name
    location                     = var.location
    resource_group_name          = var.rg_name
    allocation_method            = "Dynamic"

    tags = {
        environment = "Dev"
    }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
    name                = "${var.prefix}-nsg"
    location            = var.location
    resource_group_name = var.rg_name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = "Terraform Demo"
    }
}


# Create network interface
resource "azurerm_network_interface" "nic" {
    name                      = "${var.prefix}-nic"
    location                  = var.location
    resource_group_name       = var.rg_name

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = azurerm_subnet.subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.ip.id
    }

    tags = {
        environment = "Terraform Demo"
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "nic_nsg_association" {
    
    network_interface_id      = azurerm_network_interface.nic.id
    network_security_group_id = azurerm_network_security_group.nsg.id
}