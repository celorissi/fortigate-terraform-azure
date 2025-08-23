############################################################
# Provider Azure
############################################################
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

############################################################
# Resource Group
############################################################
resource "azurerm_resource_group" "rg" {
  name     = "rg-fgt-lab"
  location = "eastus"
}

############################################################
# Hub VNet
############################################################
resource "azurerm_virtual_network" "vnet_hub" {
  name                = "vnet-hub"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.100.0.0/16"]
}

resource "azurerm_subnet" "subnet_outside" {
  name                 = "snet-outside"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_hub.name
  address_prefixes     = ["10.100.1.0/24"]
}

resource "azurerm_subnet" "subnet_inside" {
  name                 = "snet-inside"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_hub.name
  address_prefixes     = ["10.100.2.0/24"]
}

resource "azurerm_subnet" "subnet_protect" {
  name                 = "snet-protect"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_hub.name
  address_prefixes     = ["10.100.3.0/24"]
}

resource "azurerm_subnet" "subnet_mgmt" {
  name                 = "snet-mgmt"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_hub.name
  address_prefixes     = ["10.100.4.0/24"]
}

############################################################
# Spoke1 VNet
############################################################
resource "azurerm_virtual_network" "vnet_spoke1" {
  name                = "vnet-spoke1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.1.0.0/22"]
}

resource "azurerm_subnet" "subnet_spoke1" {
  name                 = "snet-spoke1"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_spoke1.name
  address_prefixes     = ["10.1.1.0/24"]
}

############################################################
# Spoke2 VNet
############################################################
resource "azurerm_virtual_network" "vnet_spoke2" {
  name                = "vnet-spoke2"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.2.0.0/16"]
}

resource "azurerm_subnet" "subnet_spoke2" {
  name                 = "snet-spoke2"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_spoke2.name
  address_prefixes     = ["10.2.1.0/24"]
}

############################################################
# VNet Peerings
############################################################
resource "azurerm_virtual_network_peering" "hub_to_spoke1" {
  name                         = "hub-to-spoke1"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.vnet_hub.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_spoke1.id
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "spoke1_to_hub" {
  name                         = "spoke1-to-hub"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.vnet_spoke1.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_hub.id
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "hub_to_spoke2" {
  name                         = "hub-to-spoke2"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.vnet_hub.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_spoke2.id
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "spoke2_to_hub" {
  name                         = "spoke2-to-hub"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.vnet_spoke2.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_hub.id
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
}

############################################################
# Network Interfaces
############################################################
resource "azurerm_network_interface" "nic_spoke1" {
  name                = "nic-spoke1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet_spoke1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "nic_spoke2" {
  name                = "nic-spoke2"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet_spoke2.id
    private_ip_address_allocation = "Dynamic"
  }
}

############################################################
# Linux VMs
############################################################
resource "azurerm_linux_virtual_machine" "vm_spoke1" {
  name                            = "vm-spoke1"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = "Standard_B1s"
  admin_username                  = "azureadmin"
  admin_password                  = "senhaforte@123"
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.nic_spoke1.id]

  os_disk {
    name                 = "disk-vm-spoke1"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }


}

resource "azurerm_linux_virtual_machine" "vm_spoke2" {
  name                            = "vm-spoke2"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = "Standard_B1s"
  admin_username                  = "azureadmin"
  admin_password                  = "senhaforte@123"
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.nic_spoke2.id]

  os_disk {
    name                 = "disk-vm-spoke2"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

############################################################
# UDR - Route Tables
############################################################
resource "azurerm_route_table" "rt_spoke1" {
  name                = "rt-spoke1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_route" "route_spoke1_to_fw" {
  name                   = "route-to-fw"
  resource_group_name    = azurerm_resource_group.rg.name
  route_table_name       = azurerm_route_table.rt_spoke1.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = "10.100.2.4"
}

resource "azurerm_subnet_route_table_association" "assoc_spoke1" {
  subnet_id      = azurerm_subnet.subnet_spoke1.id
  route_table_id = azurerm_route_table.rt_spoke1.id
}

resource "azurerm_route_table" "rt_spoke2" {
  name                = "rt-spoke2"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_route" "route_spoke2_to_fw" {
  name                   = "route-to-fw"
  resource_group_name    = azurerm_resource_group.rg.name
  route_table_name       = azurerm_route_table.rt_spoke2.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = "10.100.2.4"
}

resource "azurerm_subnet_route_table_association" "assoc_spoke2" {
  subnet_id      = azurerm_subnet.subnet_spoke2.id
  route_table_id = azurerm_route_table.rt_spoke2.id
}

############################################################
# NSGs
############################################################
resource "azurerm_network_security_group" "nsg_outside" {
  name                = "nsg-outside"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTPS"
    priority                   = 105
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-ICMP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "nsg_inside" {
  name                = "nsg-inside"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

############################################################
# NSG Associations
############################################################
resource "azurerm_subnet_network_security_group_association" "assoc_nsg_outside" {
  subnet_id                 = azurerm_subnet.subnet_outside.id
  network_security_group_id = azurerm_network_security_group.nsg_outside.id
}

resource "azurerm_subnet_network_security_group_association" "assoc_spoke1_nsg" {
  subnet_id                 = azurerm_subnet.subnet_spoke1.id
  network_security_group_id = azurerm_network_security_group.nsg_inside.id
}

resource "azurerm_subnet_network_security_group_association" "assoc_spoke2_nsg" {
  subnet_id                 = azurerm_subnet.subnet_spoke2.id
  network_security_group_id = azurerm_network_security_group.nsg_inside.id
}
