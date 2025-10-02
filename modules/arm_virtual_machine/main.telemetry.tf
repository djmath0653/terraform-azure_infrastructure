
locals {
  valid_module_source_regex = [
    "registry.terraform.io/[A|a]zure/.+",
    "registry.opentofu.io/[A|a]zure/.+",
    "git::https://github\\.com/[A|a]zure/.+",
    "git::ssh:://git@github\\.com/[A|a]zure/.+",
  ]
}

locals {
  main_location = var.location
}

