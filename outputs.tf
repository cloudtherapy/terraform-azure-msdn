output "resource_group_name" {
  description = "The name of the created resource group."
  value       = azurerm_resource_group.rg.name
}

output "virtual_network_name" {
  description = "The name of the created virtual network."
  value       = azurerm_virtual_network.msdn_network.name
}

output "subnet_name_1" {
  description = "The name of the created subnet 1."
  value       = azurerm_subnet.msdn_subnet_1.name
}

output "subnet_name_2" {
  description = "The name of the created subnet 2."
  value       = azurerm_subnet.msdn_subnet_2.name
}