##################################################################################
# External Load Balancer
##################################################################################

# This is the module call
module "public_ip_address" {
  source = "../../modules/arm_public_ip_address"

  name                = var.ext_lb_pip_name
  resource_group_name = module.fw_resource_group.name
  location            = module.fw_resource_group.location
}

module "exteranl_loadbalancer" {
  source = "../../modules/arm_network_load_balancer"

  name                = var.ext_lb_name
  resource_group_name = module.fw_resource_group.name
  location            = module.fw_resource_group.location
  frontend_ip_configurations = {
    frontend_configuration_1 = {
      name                          = "${local.lower_fw_vm_name}-frontend"
      public_ip_address_resource_id = module.public_ip_address.resource_id
      zones                         = ["None"]
    }
  }
  backend_address_pools = {
    pool1 = {
      name = "${local.lower_fw_vm_name}-external-pool"
    }
  }
  backend_address_pool_network_interfaces = {
    node1 = {
      backend_address_pool_object_name = "pool1"
      network_interface_resource_id    = module.firewall_pair[0].network_interfaces.network_interface_1.id
      ip_configuration_name            = "ipconfig1-${module.virtual_network.subnet["palo-untrust-Subnet-01"].name}"
    }
    node2 = {
      backend_address_pool_object_name = "pool1"
      network_interface_resource_id    = module.firewall_pair[1].network_interfaces.network_interface_1.id
      ip_configuration_name            = "ipconfig1-${module.virtual_network.subnet["palo-untrust-Subnet-01"].name}"
    }
  }
  lb_probes = {
    ssh = {
      name                = "ssh_probe"
      port                = 22
      interval_in_seconds = 5
    }
  }
  lb_rules = {
    rdp = {
      name                              = "rdp"
      frontend_ip_configuration_name    = "${local.lower_fw_vm_name}-frontend"
      protocol                          = "Tcp"
      frontend_port                     = 3389
      backend_address_pool_object_names = ["pool1"]
      backend_port                      = 3389
      probe_object_name                 = "ssh"
      disable_outbound_snat             = true # set `diasble_outbound_snat` to true when same frontend ip configuration is referenced by outbout rule and lb rule
    }
  }
  # diagnostic_settings = {
  #   diag = {
  #     workspace_resource_id = local.workspace_resource_id
  #   }
  # }
}
