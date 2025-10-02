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
# ADDS network variables
##################################################################################
variable "rg_name" {
  type    = string
  default = "adds-p-networking-rg01"
}

variable "vnet_name" {
  type    = string
  default = "adds-p-vnet01"
}

variable "address_space" {
  type    = list(any)
  default = ["172.20.6.0/24"]
}

variable "subnets" {
  default = {
    "adds-snet01" = {
      cidrs                           = ["172.20.6.0/28"]
      "create_network_security_group" = true
      "configure_nsg_rules"           = false
      "route_table_association"       = "adds-snet01-rt"
    }
    # "dns-inbound-snet01" = {
    #   cidrs                           = ["172.20.6.16/28"]
    #   "create_network_security_group" = true
    #   "configure_nsg_rules"           = false
    # }
    # "dns-outbound-snet01" = {
    #   cidrs                           = ["172.20.6.32/28"]
    #   "create_network_security_group" = true
    #   "configure_nsg_rules"           = false
    # }
  }
}

variable "route_tables" {
  description = "Maps of route tables"
  type        = map(any)
  default = {
    adds-snet01-rt = {
      bgp_route_propagation_enabled = false
      use_inline_routes             = true # Setting to true will revert any external route additions.
      routes = {
        default = {
          "address_prefix"         = "0.0.0.0/0"
          "next_hop_type"          = "VirtualAppliance"
          "next_hop_in_ip_address" = "172.20.0.174"
        }
        vnet = {
          "address_prefix"         = "172.20.6.0/24"
          "next_hop_type"          = "VirtualAppliance"
          "next_hop_in_ip_address" = "172.20.0.174"
        }
      }
    }
    # keys are route names, value map is route properties (address_prefix, next_hop_type, next_hop_in_ip_address)
    # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table#route
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
      use_remote_gateways          = false
    }
  }
}

##################################################################################
# Test VM variables
##################################################################################
variable "vm_rg_name" {
  type    = string
  default = "adds-p-vm-rg01"
}

variable "vm_name" {
  type    = string
  default = "ADDS-TEST"
}

variable "username" {
  type    = string
  default = "azureuser"
}

variable "password" {
  type    = string
  default = "PaloAlto123!"
}

