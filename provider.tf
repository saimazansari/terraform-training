terraform {
  cloud {

    organization = "saint_gobain"

    workspaces {
      name = "project1-w1"
    }
  }
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.23.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {

  }

  subscription_id = var.sid
  tenant_id       = var.tid
  client_id       = var.cid
  client_secret   = var.cs

}