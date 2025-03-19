terraform {
  cloud {
    organization = "saintgobain"
    ## Required for Terraform Enterprise; Defaults to app.terraform.io for Terraform Cloud
    hostname = "app.terraform.io"

    workspaces {
      tags = ["terraformclouddemo"]
    }
  }
}

resource "azurerm_resource_group" "saima-rg" {
  name     = "saima"
  location = var.region
tags = {
     "owner" = "sg1"
  }

}

resource "azurerm_virtual_network" "vnet1" {
  name = "vnet_saima"
  location = var.region
  address_space = ["91.91.91.0/25"]
  resource_group_name = azurerm_resource_group.saima-rg.name
tags = {
     "owner" = "sg1"
  }
  
}

resource "azurerm_virtual_network" "vnet2" {
  name = "vnet_saima2"
  location = var.region
  address_space = ["90.91.91.0/25"]
  resource_group_name = azurerm_resource_group.saima-rg.name
tags = {
     "owner" = "sg1"
  }
  
}

