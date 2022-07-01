# terraform {
#   required_providers {
#     azapi = {
#       source  = "azure/azapi"
#       version = "= 0.2.0"
#     }
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "=3.5.0"
#     }
#   }
# }


terraform {
  required_providers {
    azurerm = {
      version = "~> 3.5.0"
    }
  }
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "TerraformDemolocal"

    workspaces {
      name = "terraform-app-reg"
    }
  }
}

# provider "azapi" {
# }

provider "azurerm" {
  features {}
}


provider "azuread" {
  alias = "azuread_fmg_aad_group_admin"

  tenant_id     = var.aad_tenant_id
  client_id     = var.aad_client_id
  client_secret = var.aad_client_secret_id

}

data "azuread_client_config" "current" {}