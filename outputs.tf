##############################################
# LXC Outputs
##############################################

output "ipv4" {
  description = "IPv4 addresses assigned to the LXC network interfaces."
  value       = proxmox_virtual_environment_container.lxc.ipv4
}

output "vm_id" {
  description = "Proxmox CT ID of the LXC container."
  value       = proxmox_virtual_environment_container.lxc.vm_id
}

output "hostname" {
  description = "Hostname of the LXC container."
  value       = proxmox_virtual_environment_container.lxc.initialization[0].hostname
}

output "node_name" {
  description = "Proxmox node hosting the LXC container."
  value       = proxmox_virtual_environment_container.lxc.node_name
}
