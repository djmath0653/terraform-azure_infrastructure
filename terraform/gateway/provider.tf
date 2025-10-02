# providers block

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.14.0"
    }
  }
}

provider "azurerm" {
   features {}
 }

terraform {
  # Backend variables are initialized by Azure DevOps
  backend "azurerm" {}
}

