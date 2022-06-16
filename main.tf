terraform {
  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "= 0.2.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.5.0"
    }
  }
}

provider "azapi" {
}

provider "azurerm" {
  features {}
}


data "azuread_client_config" "current" {}