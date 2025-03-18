resource "azurerm_virtual_network" "vnet1" {
  resource_group_name = data.azurerm_resource_group.saima-rg.name
  location            = data.azurerm_resource_group.saima-rg.location
  name                = "vnet1"
  address_space       = ["91.91.91.0/24"]

}
resource "azurerm_subnet" "vnet1-s1" {
  resource_group_name  = data.azurerm_resource_group.saima-rg.name
  name                 = "vnet1-s1"
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["91.91.91.0/25"]

}

resource "azurerm_subnet" "vnet1-s2" {
  resource_group_name  = data.azurerm_resource_group.saima-rg.name
  name                 = "vnet1-s2"
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["91.91.91.128/25"]

}

resource "azurerm_network_interface" "nic1" {
  resource_group_name = data.azurerm_resource_group.saima-rg.name
  location            = data.azurerm_resource_group.saima-rg.location
  name                = "nic1"
  ip_configuration {
    name                          = "ip1"
    subnet_id                     = azurerm_subnet.vnet1-s1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip1.id

  }

}

resource "azurerm_public_ip" "pip1" {
  resource_group_name = data.azurerm_resource_group.saima-rg.name
  location            = data.azurerm_resource_group.saima-rg.location
  name                = "pip1"
  allocation_method   = "Static"

}

resource "azurerm_subnet_network_security_group_association" "sg1" {
  subnet_id                 = azurerm_subnet.vnet1-s1.id
  network_security_group_id = azurerm_network_security_group.sg1.id

}

resource "azurerm_subnet_network_security_group_association" "sg2" {
  subnet_id                 = azurerm_subnet.vnet1-s2.id
  network_security_group_id = azurerm_network_security_group.sg1.id
}

resource "azurerm_network_security_group" "sg1" {
  resource_group_name = data.azurerm_resource_group.saima-rg.name
  location            = data.azurerm_resource_group.saima-rg.location
  name                = "sg3"
  security_rule  {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    destination_address_prefix = "*"
    source_address_prefix = "*"

  }
}

resource "azurerm_linux_virtual_machine" "name" {
  name                            = "vm1"
  resource_group_name             = data.azurerm_resource_group.saima-rg.name
  location                        = data.azurerm_resource_group.saima-rg.location
  size                            = "Standard_B1s"
  admin_username                  = "docker"
  admin_password                  = "Docker@12345"
  disable_password_authentication = "false"
  network_interface_ids           = [azurerm_network_interface.nic1.id]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"

  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

}

output "public_ip_address_id" {
  value = azurerm_public_ip.pip1.ip_address
}