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
  count               = var.numberofvms
  resource_group_name = data.azurerm_resource_group.saima-rg.name
  location            = data.azurerm_resource_group.saima-rg.location
  name                = "nic1-${count.index}"
  ip_configuration {
    name                          = "ip1"
    subnet_id                     = azurerm_subnet.vnet1-s1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip1[count.index].id

  }
}

resource "azurerm_public_ip" "pip1" {
  count               = var.numberofvms
  resource_group_name = data.azurerm_resource_group.saima-rg.name
  location            = data.azurerm_resource_group.saima-rg.location
  name                = "pip1-${count.index}"
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
  dynamic "security_rule" {
    for_each = var.security_rule
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = security_rule.value.protocol
      destination_port_range     = security_rule.value.dport
      source_port_range          = "*"
      destination_address_prefix = "*"
      source_address_prefix      = "*"
    }
  }
}

resource "azurerm_linux_virtual_machine" "name" {
  count                           = var.numberofvms
  name                            = "vm1-${count.index}"
  resource_group_name             = data.azurerm_resource_group.saima-rg.name
  location                        = data.azurerm_resource_group.saima-rg.location
  size                            = "Standard_B1s"
  admin_username                  = "docker"
  admin_password                  = "Docker@12345"
  network_interface_ids           = [azurerm_network_interface.nic1[count.index].id]
  disable_password_authentication = "false"
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


  provisioner "file" {
    source      = "web.sh"
    destination = "/tmp/web.sh"

  }
  provisioner "local-exec" {
    command = "echo ${self.public_ip_address} > private_ip.txt"
  }
  provisioner "file" {
    source      = "index.html"
    destination = "/tmp/index.html"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo setfacl -m u:docker:rwx /var/www/html/",
      "sudo setfacl -m u:docker:rwx /tmp/",
      "sudo chmod +x /tmp/web.sh",
      "sudo /tmp/web.sh",
      "sudo cp /tmp/index.html /var/www/html/index.html"
    ]

  }
  connection {
    type     = "ssh"
    user     = "docker"
    password = "Docker@12345"
    host     = self.public_ip_address
    timeout  = "3m"
  }
}
output "public_ip_address_id" {
  value = azurerm_public_ip.pip1[*].ip_address
}