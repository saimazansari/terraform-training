data "azurerm_resource_group" "saima-rg" {
  name = "dev"
  #   location = var.region

}

data "azurerm_storage_account" "e1-sa1" {
  name                = "commonstorageacc2103"
  resource_group_name = "rg-test-21"

}

data "azurerm_platform_image" "e1-pi1" {
  publisher = "Canonical"
  offer     = "UbuntuServer"
  sku       = "18.04-LTS"
  #version = "latest"
  location = "eastus"

}

output "osdata" {
  value = data.azurerm_platform_image.e1-pi1.id

}

output "resource_group_name" {
  value = data.azurerm_resource_group.saima-rg.name
}

output "location_of_resource_group" {
  value = data.azurerm_resource_group.saima-rg.location

}

output "storage_account_name" {
  value = data.azurerm_storage_account.e1-sa1.id

}

# output "storage_key" {
#   value = data.azurerm_resource_group.e1-sa1.primary_access_key
#   sensitive = true

# }

output "storage_account_location" {
  value     = data.azurerm_storage_account.e1-sa1.primary_access_key
  sensitive = true
}

output "vadapav" {
  value = data.azurerm_storage_account.e1-sa1.primary_blob_endpoint

}

