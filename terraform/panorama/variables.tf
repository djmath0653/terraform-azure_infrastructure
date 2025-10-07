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
  type = string
  default = "hub-p-logs-rg01"
}

variable "log_workspace_name" {
  type = string
  default = "hub-p-law01"
}

##################################################################################
# Connectivity network variables
##################################################################################
variable "rg_name" {
  type    = string
  default = "P-Networking-PANO-RG01"
}

variable "vnet_name" {
  type    = string
  default = "pano-p-vnet01"
}

variable "address_space" {
  type    = list(any)
  default = ["172.20.4.0/24"]
}

variable "subnets" {
  default = {
    "pano-mgtmt-snet01" = { cidrs = ["172.20.4.0/26"]
      "create_network_security_group" = true
      "configure_nsg_rules"           = false
    }
  }
}

variable "peers" {
  description = "Peer virtual networks.  Keys are names, allowed values are same as for peer_defaults. Id value is required."
  type        = any
  default = {
    "hb-p-HUB-vnet-01" = {
      id                           = "/subscriptions/1cbd70a5-1547-4183-846f-12003f04578c/resourceGroups/P-Networking-HUB-RG01/providers/Microsoft.Network/virtualNetworks/hb-p-HUB-vnet-01"
      allow_virtual_network_access = true
      allow_forwarded_traffic      = true
      allow_gateway_transit        = false
      use_remote_gateways          = true
    }
  }
}

##################################################################################
# Panorama variables
##################################################################################
variable "pano_rg_name" {
  type    = string
  default = "P-Pano-RG01"
}

variable "pano_vm_name" {
  type    = string
  default = "AZU-PPANO01"
}

variable "username" {
  type    = string
  default = "azureuser"
}

variable "password" {
  type    = string
  default = "PaloAlto123!"
}

