######################################################################################
# Global variables
######################################################################################
variable "subscription_id" {
  type    = string
  default = "1cbd70a5-1547-4183-846f-12003f04578c"
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "log_workspace_rg" {
  type    = string
  default = "hub-p-logs-rg01"
}

variable "log_workspace_name" {
  type    = string
  default = "hub-p-law01"
}

##################################################################################
# Connectivity network variables
##################################################################################
variable "rg_name" {
  type    = string
  default = "P-Networking-HUB-RG01"
}

variable "vnet_name" {
  type    = string
  default = "hb-p-HUB-vnet-01"
}

variable "address_space" {
  type    = list(any)
  default = ["172.20.0.0/22"]
}

variable "subnets" {
  default = {
    "GatewaySubnet" = { cidrs = ["172.20.0.0/26"]
    }
    "palo-mgtmt-Subnet-01" = { cidrs = ["172.20.0.128/28"]
      "create_network_security_group" = true
      "configure_nsg_rules"           = false
    }
    "palo-untrust-Subnet-01" = { cidrs = ["172.20.0.144/28"]
      "create_network_security_group" = true
      "configure_nsg_rules"           = false
    }
    "palo-trust-Subnet-01" = { cidrs = ["172.20.0.160/28"]
      "create_network_security_group" = true
      "configure_nsg_rules"           = false
    }
    "palo-ha-Subnet-01" = { cidrs = ["172.20.0.176/28"]
      "create_network_security_group" = true
      "configure_nsg_rules"           = false
    }
  }
}

variable "route_tables" {
  description = "Maps of route tables"
  type        = map(any)
  default = { }
}

variable "peers" {
  default = {
    "adds-p-vnet01" = {
      id                           = "/subscriptions/1cbd70a5-1547-4183-846f-12003f04578c/resourceGroups/adds-p-networking-rg01/providers/Microsoft.Network/virtualNetworks/adds-p-vnet01"
      allow_virtual_network_access = true
      allow_forwarded_traffic      = true
      allow_gateway_transit        = false
      use_remote_gateways          = false
    }
  }
}

##################################################################################
# Firewall variables
##################################################################################
variable "fw_rg_name" {
  type    = string
  default = "P-Palo-RG01"
}

variable "fw_vm_name" {
  type    = string
  default = "AZU-PPALO01"
}

variable "username" {
  type    = string
  default = "azureuser"
}

variable "password" {
  type    = string
  default = "PaloAlto123!"
}

##################################################################################
# External Load Balancer variables
##################################################################################
variable "ext_lb_pip_name" {
  type    = string
  default = "lb-palo-elb01-pip01"
}

variable "ext_lb_name" {
  type    = string
  default = "lb-palo-elb01"
}

variable "int_lb_name" {
  type    = string
  default = "lb-palo-ilb01"
}

variable "frontend_private_ip_address" {
  type    = string
  default = "172.20.0.174"
}

##################################################################################
# Virtual Network Gateway variables
##################################################################################
variable "vpn_pip_name" {
  type    = string
  default = "gwy-vpn-p-pip"
}

variable "vpn_vng_name" {
  type    = string
  default = "gwy-vpn-p-vng"
}

variable "vpn_vng_sku" {
  type    = string
  default = "VpnGw1"
}

variable "vpn_vng_type" {
  type    = string
  default = "Vpn"
}

variable "vpn_lng_name" {
  type    = string
  default = "gwy-vpn-p-lng"
}

variable "vpn_lng_ip_addess" {
  type    = string
  default = "73.50.100.28"
}

variable "vpn_lng_addess_space" {
  type    = list(string)
  default = ["192.168.0.0/16"]
}

variable "vpn_connection_name" {
  type    = string
  default = "gwy-vpn-p-lng-connection"
}

##################################################################################
# ExpressRoute Gateway variables
##################################################################################

variable "er_pip_name" {
  type    = string
  default = "gwy-er-p-pip"
}

variable "er_vng_name" {
  type    = string
  default = "gwy-er-p-vng"
}

variable "er_vng_sku" {
  type    = string
  default = "Standard"
}

variable "er_vng_type" {
  type    = string
  default = "ExpressRoute"
}