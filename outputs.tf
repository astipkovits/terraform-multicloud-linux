output "linux_mgmt_ip" {
  value = var.cloud == "azure" ? azurerm_public_ip.linux_vm_pubip[0].ip_address : var.cloud == "aws" ? module.ec2_instance[0].public_ip : null
}

output "linux_private_ip" {
  value = var.cloud == "azure" ? azurerm_network_interface.linux_vm_iface[0].private_ip_address : var.cloud == "aws" ? module.ec2_instance[0].private_ip : null
}