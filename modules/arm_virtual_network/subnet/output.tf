output "id" {
  description = "subnet id"
  value       = azurerm_subnet.subnet.id
}

output "name" {
  description = "subnet name"
  value       = azurerm_subnet.subnet.name
}

output "network_security_group_id" {
  description = "network security group id"
  value       = (azurerm_subnet.subnet.name != "RouteServerSubnet" && azurerm_subnet.subnet.name != "GatewaySubnet" &&   var.create_network_security_group ? azurerm_network_security_group.nsg.0.id : null)
}

output "network_security_group_name" {
  description = "network security group name"
  value       = (azurerm_subnet.subnet.name != "RouteServerSubnet" && azurerm_subnet.subnet.name != "GatewaySubnet" && var.create_network_security_group ? azurerm_network_security_group.nsg.0.name : null)
}

output "subnet" {
  description = "subnet data object"
  value       = azurerm_subnet.subnet
}
