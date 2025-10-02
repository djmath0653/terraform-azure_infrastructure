locals {
  naming_rules = (var.naming_rules != "" ? yamldecode(var.naming_rules) : null)

  network_security_group_name = "nsg-${var.subnet_name}" 
}
