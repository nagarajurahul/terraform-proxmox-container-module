# https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_container
resource "proxmox_virtual_environment_container" "lxc" {
  node_name = var.node_name
  vm_id     = var.vm_id

  description = var.description
  tags        = var.tags

  started       = var.started
  start_on_boot = var.start_on_boot
  unprivileged  = var.unprivileged

  cpu {
    cores = var.cpu
  }

  memory {
    dedicated = var.memory
    swap      = var.swap
  }

  disk {
    datastore_id = var.datastore_id
    size         = var.disk_size
  }

  operating_system {
    template_file_id = proxmox_download_file.lxc_template.id
    type             = var.operating_system
  }

  initialization {
    hostname = var.hostname

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      keys = var.ssh_authorized_keys
    }

    dns {
      domain  = var.dns_domain
      servers = var.dns_servers
    }
  }

  network_interface {
    name   = var.network_interface_name
    bridge = var.network_bridge
  }

  features {
    nesting = var.enable_nesting
  }
}

# https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/download_file
resource "proxmox_download_file" "lxc_template" {
  content_type = "vztmpl"
  datastore_id = var.datastore_id
  node_name    = var.node_name

  url = var.template_url
}