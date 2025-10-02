##################################################################################
# Route Server network 
##################################################################################
module "resource_group" {
  source = "../../modules/arm_resource_group"

  name     = var.rg_name
  location = var.location
  tags     = var.tags
}

module "virtual_network" {
  source = "../../modules/arm_virtual_network"

  resource_group_name  = module.resource_group.name
  location             = module.resource_group.location
  virtual_network_name = var.vnet_name
  address_space        = var.address_space
  subnets              = var.subnets
  route_tables         = var.route_tables
  peers                = var.peers
  tags                 = var.tags
  diagnostic_settings = {
    diag = {
      workspace_resource_id = local.workspace_resource_id
    }
  }
}

module "vm_resource_group" {
  source = "../../modules/arm_resource_group"

  name     = var.vm_rg_name
  location = var.location
  tags     = var.tags
}

module "test_machine" {
  source = "../../modules/arm_virtual_machine"
  count  = 1

  name                = "${var.vm_name}-0${count.index + 1}"
  resource_group_name = module.vm_resource_group.name
  location            = module.vm_resource_group.location
  zone                = count.index + 1
  os_type             = "Linux"
  source_image_reference = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
  account_credentials = {
    admin_credentials = {
      username                           = var.username
      password                           = var.password
      generate_admin_password_or_ssh_key = false
    }
    password_authentication_disabled = false
  }
  network_interfaces = {
    network_interface_0 = {
      name = "${var.vm_name}-0${count.index + 1}-nic0"
      ip_configurations = {
        ip_configuration_1 = {
          name                          = "ipconfig1"
          private_ip_subnet_resource_id = module.virtual_network.subnet["adds-snet01"].id
          private_ip_address            = "172.20.6.${count.index + 4}"
          private_ip_address_allocation = "Static"

        }
      }
    }
  }
  vm_additional_capabilities = {
    ultra_ssd_enabled = true
  }
  boot_diagnostics = true
}
