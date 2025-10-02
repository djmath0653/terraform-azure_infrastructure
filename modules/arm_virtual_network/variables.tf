variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "virtual_network_name" {
  description = "use product_name as prefix for VNET resource"
  type        = string
  default     = ""
}

variable "location" {
  description = "Azure Region"
  type        = string
}

# variable "names" {
#   description = "Names to be applied to resources"
#   type        = map(string)
# }

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
}

variable "naming_rules" {
  description = "naming conventions yaml file"
  type        = string
  default     = ""
}

variable "enforce_subnet_names" {
  description = "enforce subnet names based on naming_rules variable"
  type        = bool
  default     = true
}

# Networking
variable "address_space" {
  description = "CIDRs for virtual network"
  type        = list(string)
}

variable "dns_servers" {
  description = "If applicable, a list of custom DNS servers to use inside your virtual network.  Unset will use default Azure-provided resolver"
  type        = list(string)
  default     = null
}

variable "subnets" {
  description = "Map of subnets. Keys are subnet names, Allowed values are the same as for subnet_defaults"
  type        = any
  default     = {}

  validation {
    condition = (length(compact([for subnet in var.subnets : (!lookup(subnet, "configure_nsg_rules", true) &&
      (contains(keys(subnet), "allow_internet_outbound") ||
        contains(keys(subnet), "allow_lb_inbound") ||
        contains(keys(subnet), "allow_vnet_inbound") ||
      contains(keys(subnet), "allow_vnet_outbound")) ?
    "invalid" : "")])) == 0)
    error_message = "Subnet rules not allowed when configure_nsg_rules is set to \"false\"."
  }
}

variable "aks_subnets" {
  description = "AKS subnets"
  type = map(object({
    subnet_info = any
    route_table = object({
      bgp_route_propagation_enabled = bool
      routes                        = map(map(string))
      # keys are route names, value map is route properties (address_prefix, next_hop_type, next_hop_in_ip_address)
      # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table#route
    })
  }))
  default = null
}

variable "subnet_defaults" {
  description = "Maps of CIDRs, policies, endpoints and delegations"
  type = object({
    cidrs                                         = list(string)
    private_endpoint_network_policies             = string
    private_link_service_network_policies_enabled = bool
    service_endpoints                             = list(string)
    delegations = map(object({
      name    = string
      actions = list(string)
    }))
    create_network_security_group = bool   # create/associate network security group with subnet
    security_group_prefix         = string # prefix for network security group name
    configure_nsg_rules           = bool   # deny ingress/egress traffic and configure nsg rules based on below parameters
    allow_internet_outbound       = bool   # allow outbound traffic to internet (configure_nsg_rules must be set to true)
    allow_lb_inbound              = bool   # allow inbound traffic from Azure Load Balancer (configure_nsg_rules must be set to true)
    allow_vnet_inbound            = bool   # allow all inbound from virtual network (configure_nsg_rules must be set to true)
    allow_vnet_outbound           = bool   # allow all outbound from virtual network (configure_nsg_rules must be set to true)
    route_table_association       = string
  })
  default = {
    cidrs                                         = []
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
    service_endpoints                             = []
    delegations                                   = {}
    create_network_security_group                 = true
    security_group_prefix                         = null
    configure_nsg_rules                           = true
    allow_internet_outbound                       = false
    allow_lb_inbound                              = false
    allow_vnet_inbound                            = false
    allow_vnet_outbound                           = false
    route_table_association                       = null
  }
}

variable "route_tables" {
  description = "Maps of route tables"
  type = map(object({
    bgp_route_propagation_enabled = bool
    use_inline_routes             = bool # Setting to true will revert any external route additions.
    routes                        = map(map(string))
    # keys are route names, value map is route properties (address_prefix, next_hop_type, next_hop_in_ip_address)
    # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table#route
  }))
  default = {}
}

variable "peers" {
  description = "Peer virtual networks.  Keys are names, allowed values are same as for peer_defaults. Id value is required."
  type        = any
  default     = {}
}

variable "peer_defaults" {
  description = "Maps of peer arguments."
  type = object({
    id                           = string
    allow_virtual_network_access = bool
    allow_forwarded_traffic      = bool
    allow_gateway_transit        = bool
    use_remote_gateways          = bool
  })
  default = {
    id                           = null  # remote virtual network id
    allow_virtual_network_access = true  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering#allow_virtual_network_access
    allow_forwarded_traffic      = false # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering#allow_forwarded_traffic
    allow_gateway_transit        = false # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering#allow_gateway_transit
    use_remote_gateways          = false # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering#use_remote_gateways
  }
}

variable "diagnostic_settings" {
  type = map(object({
    name                                     = optional(string, null)
    log_categories                           = optional(set(string), [])
    log_groups                               = optional(set(string), ["allLogs"])
    metric_categories                        = optional(set(string), ["AllMetrics"])
    log_analytics_destination_type           = optional(string, "Dedicated")
    workspace_resource_id                    = optional(string, null)
    storage_account_resource_id              = optional(string, null)
    event_hub_authorization_rule_resource_id = optional(string, null)
    event_hub_name                           = optional(string, null)
    marketplace_partner_resource_id          = optional(string, null)
  }))
  default     = {}
  description = <<DESCRIPTION
A map of diagnostic settings to create on the ddos protection plan. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `name` - (Optional) The name of the diagnostic setting. One will be generated if not set, however this will not be unique if you want to create multiple diagnostic setting resources.
- `log_categories` - (Optional) A set of log categories to send to the log analytics workspace. Defaults to `[]`.
- `log_groups` - (Optional) A set of log groups to send to the log analytics workspace. Defaults to `["allLogs"]`.
- `metric_categories` - (Optional) A set of metric categories to send to the log analytics workspace. Defaults to `["AllMetrics"]`.
- `log_analytics_destination_type` - (Optional) The destination type for the diagnostic setting. Possible values are `Dedicated` and `AzureDiagnostics`. Defaults to `Dedicated`.
- `workspace_resource_id` - (Optional) The resource ID of the log analytics workspace to send logs and metrics to.
- `storage_account_resource_id` - (Optional) The resource ID of the storage account to send logs and metrics to.
- `event_hub_authorization_rule_resource_id` - (Optional) The resource ID of the event hub authorization rule to send logs and metrics to.
- `event_hub_name` - (Optional) The name of the event hub. If none is specified, the default event hub will be selected.
- `marketplace_partner_resource_id` - (Optional) The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic LogsLogs.
DESCRIPTION
  nullable    = false

  validation {
    condition     = alltrue([for _, v in var.diagnostic_settings : contains(["Dedicated", "AzureDiagnostics"], v.log_analytics_destination_type)])
    error_message = "Log analytics destination type must be one of: 'Dedicated', 'AzureDiagnostics'."
  }
  validation {
    condition = alltrue(
      [
        for _, v in var.diagnostic_settings :
        v.workspace_resource_id != null || v.storage_account_resource_id != null || v.event_hub_authorization_rule_resource_id != null || v.marketplace_partner_resource_id != null
      ]
    )
    error_message = "At least one of `workspace_resource_id`, `storage_account_resource_id`, `marketplace_partner_resource_id`, or `event_hub_authorization_rule_resource_id`, must be set."
  }
}