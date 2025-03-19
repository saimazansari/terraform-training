resource "azurerm_resource_group" "saima-rg" {
  name     = "saima"
  location = var.region

}

resource "azurerm_virtual_network" "vnet1" {
  name = "vnet_saima"
  location = var.region
  address_space = ["91.91.91.0/25"]
  resource_group_name = azurerm_resource_group.saima-rg.name
  
}

resource "azurerm_virtual_network" "vnet2" {
  name = "vnet_saima2"
  location = var.region
  address_space = ["90.91.91.0/25"]
  resource_group_name = azurerm_resource_group.saima-rg.name
  
}

tags = {
Environment = "Prod"
Owner = "Dev"
}
