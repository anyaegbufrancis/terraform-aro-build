## Jump Host Subnet
resource "azurerm_subnet" "jumphost-subnet" {
  count                = var.create_jumphost ? 1 : 0
  name                 = var.aro_jumphost_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = local.vnet_name
  address_prefixes     = [var.aro_jumphost_subnet_cidr_block]
  service_endpoints    = ["Microsoft.ContainerRegistry"]
}

# Due to remote-exec issue Static allocation needs
# to be used - https://github.com/hashicorp/terraform/issues/21665
resource "azurerm_public_ip" "jumphost-pip" {
  count               = var.create_jumphost ? 1 : 0
  name                = var.aro_jumphost_pip_name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  tags                = var.tags
}

resource "azurerm_network_interface" "jumphost-nic" {
  count               = var.create_jumphost ? 1 : 0
  name                = var.aro_jumphost_nic_name
  resource_group_name = var.resource_group_name
  location            = var.location
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.jumphost-subnet.0.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jumphost-pip.0.id
  }
  tags = var.tags
}

resource "azurerm_network_security_group" "jumphost-nsg" {
  count               = var.create_jumphost ? 1 : 0
  name                = "${var.resource_group_name}-jumphost-nsg"
  resource_group_name = var.resource_group_name
  location            = var.location

  security_rule {
    name                       = "allow_ssh_sg"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "association" {
  count                     = var.create_jumphost ? 1 : 0
  network_interface_id      = azurerm_network_interface.jumphost-nic.0.id
  network_security_group_id = azurerm_network_security_group.jumphost-nsg.0.id
}

resource "azurerm_linux_virtual_machine" "jumphost-vm" {
  count               = var.create_jumphost ? 1 : 0
  name                = var.aro_jumphost_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_D2s_v3"
  admin_username      = "aro"

  network_interface_ids = [
    azurerm_network_interface.jumphost-nic.0.id,
  ]

  admin_ssh_key {
    username   = "aro"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "8.2"
    version   = "8.2.2021040911"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = azurerm_public_ip.jumphost-pip.0.ip_address
      user        = "aro"
      private_key = file("~/.ssh/id_rsa")
    }
    inline = [
      "sudo dnf install telnet wget bash-completion -y",
      "wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz",
      "tar -xvf openshift-client-linux.tar.gz",
      "sudo mv oc kubectl /usr/bin/",
      "oc completion bash > oc_bash_completion",
      "sudo cp oc_bash_completion /etc/bash_completion.d/"
    ]
  }

  tags = var.tags
}

