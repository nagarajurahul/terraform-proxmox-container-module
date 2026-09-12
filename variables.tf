##############################################
# LXC Identity and Metadata
##############################################

variable "vm_id" {
  type        = number
  description = "Unique Proxmox CT/VM ID for the LXC container."
}

variable "hostname" {
  type        = string
  description = "Hostname assigned to the LXC container."
}

variable "description" {
  type        = string
  default     = "Terraform-provisioned LXC container"
  description = "Description shown in Proxmox."
}

variable "tags" {
  type        = list(string)
  default     = ["terraform", "lxc"]
  description = "Tags assigned to the LXC container."
}


##############################################
# Proxmox Node and Storage
##############################################

variable "node_name" {
  type        = string
  default     = "pve"
  description = "Proxmox node where the LXC will be created."
}

variable "datastore_id" {
  type        = string
  default     = "local-lvm"
  description = "Proxmox datastore used for the LXC root filesystem."
}

variable "template_file_id" {
  type        = string
  description = <<EOT
LXC template already available in Proxmox storage.

Example:
local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst
EOT
}

variable "operating_system" {
  type        = string
  default     = "ubuntu"
  description = "Operating system type for the LXC container."
}


##############################################
# Compute Resources
##############################################

variable "cpu" {
  type        = number
  default     = 2
  description = "Number of CPU cores assigned to the LXC."
}

variable "memory" {
  type        = number
  default     = 2048
  description = "Memory assigned to the LXC in MB."
}

variable "swap" {
  type        = number
  default     = 512
  description = "Swap assigned to the LXC in MB."
}

variable "disk_size" {
  type        = number
  default     = 8
  description = "Root filesystem size in GB."
}


##############################################
# Lifecycle
##############################################

variable "started" {
  type        = bool
  default     = true
  description = "Whether the LXC should be started after creation."
}

variable "start_on_boot" {
  type        = bool
  default     = true
  description = "Whether the LXC should start automatically with Proxmox."
}


##############################################
# LXC Security and Features
##############################################

variable "unprivileged" {
  type        = bool
  default     = true
  description = "Run the LXC as an unprivileged container."
}

variable "enable_nesting" {
  type        = bool
  default     = false
  description = "Enable nesting. Required when running Docker inside the LXC."
}

variable "enable_keyctl" {
  type        = bool
  default     = false
  description = "Enable keyctl support inside the LXC."
}


##############################################
# Network
##############################################

variable "network_bridge" {
  type        = string
  default     = "vmbr0"
  description = "Proxmox network bridge."
}

variable "network_interface_name" {
  type        = string
  default     = "eth0"
  description = "Network interface name inside the LXC."
}

variable "ipv4_address" {
  type        = string
  default     = "dhcp"
  description = <<EOT
IPv4 configuration.

Examples:
dhcp
10.0.0.150/24
EOT
}

variable "ipv4_gateway" {
  type        = string
  default     = null
  nullable    = true
  description = "IPv4 gateway when using a static IP."
}


##############################################
# DNS
##############################################

variable "dns_domain" {
  type        = string
  default     = ""
  description = "DNS search domain."
}

variable "dns_servers" {
  type        = list(string)
  default     = []
  description = "DNS servers configured inside the LXC."
}


##############################################
# SSH Access
##############################################

variable "ssh_authorized_keys" {
  type        = list(string)
  default     = []
  sensitive   = true
  description = "SSH public keys configured for the LXC root account."
}