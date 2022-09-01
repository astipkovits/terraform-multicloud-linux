#Azure cloud
#---------------------------------

#Create VM connected to Aviatrix Spoke to public network (for jumphost purposes)
resource "azurerm_public_ip" "linux_vm_pubip" {
  count = var.cloud == "azure" ? 1 :0
  name                = "${var.name}-pub-ip"
  resource_group_name = var.azure_resource_group
  location            = var.region
  allocation_method   = "Static"
  sku = "Standard"
}

resource "azurerm_network_interface" "linux_vm_iface" {
  count = var.cloud == "azure" ? 1 :0
  name                = "${var.name}-nic"
  location            = var.region
  resource_group_name = var.azure_resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.linux_vm_pubip[count.index].id
  }
}

resource "azurerm_network_security_group" "nsg1" {
  name                = "${var.name}-nsg"
  location            = var.region
  resource_group_name = var.azure_resource_group

  security_rule {
    name                       = "inbound-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "inbound-icmp"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "inbound-http"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "outbound-any"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "nsg_assoc" {
  network_interface_id      = azurerm_network_interface.linux_vm_iface[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg1
}

resource "azurerm_linux_virtual_machine" "linux_vm" {
  count = var.cloud == "azure" ? 1 :0
  name                = "${var.name}-vm"
  resource_group_name = var.azure_resource_group
  location            = var.region
  size                = var.size
  admin_username      = var.admin_username
  tags                = var.tags
  network_interface_ids = [
    azurerm_network_interface.linux_vm_iface[count.index].id,
  ]

  disable_password_authentication = false
  admin_password = var.admin_password

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
}

module "run_command_linux" {
  source = "registry.terraform.io/libre-devops/run-vm-command/azurerm"
  count = ((var.command != "") && (var.cloud == "azure")) ? 1 : 0 
  depends_on = [azurerm_linux_virtual_machine.linux_vm[0]]
  
  location   = var.region
  rg_name    = var.azure_resource_group
  vm_name    = "${var.name}-vm"
  os_type    = "linux"

  command = var.command
}
