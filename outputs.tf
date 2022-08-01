output "linux_mgmt_ip" {
  value = azurerm_public_ip.linux_vm_pubip.ip_address
}

output "linux_private_ip" {
  value = azurerm_network_interface.linux_vm_iface.private_ip_address
}