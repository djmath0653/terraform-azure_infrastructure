output "azurerm_public_ip" {
  description = "Outputs the entire local pip_diagnostic_settings"
  value       = module.exteranl_loadbalancer.azurerm_public_ip
}

output "pip_diagnostic_settings" {
  description = "Outputs the entire local pip_diagnostic_settings"
  value       = module.exteranl_loadbalancer.pip_diagnostic_settings
}
