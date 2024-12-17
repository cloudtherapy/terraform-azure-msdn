# Resource Group
resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = "rg-shared-services"
}

# ansible public key
resource "azurerm_ssh_public_key" "ansible" {
  name                = "ansible"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.resource_group_location
  public_key          = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCTD8HrwW7d5xvgs0o0dXkyNFdgZwab4G9Ok2Irh7uuk0OOW/U9QyePpfHzDboSsyfSGjwG3qzn6zKncq1vg2YmaR2oOm555T5D3/faGdJ1UJbx5hqiogkfw4hXMreg/u9Ah9CuucDUKwRxQC/MhpVrGb1MAEuDd5ZKPT6QF99ssgno/ibrHdraENMsZu+FxmJZ/Ukmi6ik8eJYRlSvAEZXw2hQIEcEaYejWMnNmE06ys5xjQe30pmV2a/Wxg4NN2MrDFzCssSDARAMak5v0vGkLGTsJYx56NaKLqnOudkKnPkXK/AvvEB26L1F1kaZLyR0jrzjTuKKEuqUJReKf/MV"
}

# Virtual Network
resource "azurerm_virtual_network" "msdn_network" {
  name                = "vnet-shared-10-65-16"
  address_space       = ["10.65.16.0/20"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Subnet 1
resource "azurerm_subnet" "msdn_subnet_1" {
  name                 = "snet-shared-10-60-16-0"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.msdn_network.name
  address_prefixes     = ["10.65.16.0/24"]
}

# Subnet 2
resource "azurerm_subnet" "msdn_subnet_2" {
  name                 = "snet-shared-10-60-17-0"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.msdn_network.name
  address_prefixes     = ["10.65.17.0/24"]
}

data "azurerm_virtual_network" "misfirm_network" {
  name                = "vnet-shared-10-65-0"
  resource_group_name = "rg-shared-services"
  provider            = azurerm.misfirm
}

resource "azurerm_virtual_network_peering" "peer-to-misfirm" {
  name                         = "peer_10_65_16_to_10_65_0"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.msdn_network.name
  remote_virtual_network_id    = data.azurerm_virtual_network.misfirm_network.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = true
}