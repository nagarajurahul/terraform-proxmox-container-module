# Terraform Proxmox Container Module

Reusable Terraform module for provisioning **Proxmox LXC containers** using the [`bpg/proxmox`](https://registry.terraform.io/providers/bpg/proxmox/latest) Terraform provider.

The module manages:

- LXC container creation
- Ubuntu LXC template download
- CPU, memory, swap, and disk resources
- Network configuration
- DNS configuration
- SSH authorized keys
- Unprivileged containers
- LXC nesting
- Start-on-boot behavior

## Requirements

| Component | Version |
|---|---|
| Terraform | `>= 1.14.0, < 1.20.0` |
| Proxmox Provider | `bpg/proxmox 0.113.1` |
| Proxmox VE | Compatible with provider version |

## Provider

```hcl
terraform {
  required_version = ">= 1.14.0, <1.20.0"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.113.1"
    }
  }
}
```

The provider should be configured in the root Terraform configuration and passed implicitly to this module.

## Usage

```hcl
module "lxc" {
  source = "git::https://github.com/nagarajurahul/terraform-proxmox-container-module.git?ref=<commit-sha>"

  vm_id       = 111
  hostname    = "test-lxc"
  description = "Testing LXC"
  tags        = ["terraform", "lxc", "testing"]

  node_name    = "pve"
  datastore_id = "local-lvm"

  template_url = "https://download.proxmox.com/images/system/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"

  operating_system = "ubuntu"

  cpu       = 2
  memory    = 4096
  swap      = 2048
  disk_size = 40

  unprivileged   = true
  enable_nesting = true

  network_bridge         = "vmbr0"
  network_interface_name = "eth0"

  dns_domain = "homelab.local"

  dns_servers = [
    "10.0.0.1",
    "1.1.1.1"
  ]

  ssh_authorized_keys = [
    "ssh-ed25519 AAAA..."
  ]

  started       = true
  start_on_boot = true
}
```

## LXC Template

The module downloads the LXC operating-system template using:

```hcl
resource "proxmox_download_file" "lxc_template"
```

The default template is:

```text
Ubuntu 24.04 LTS
ubuntu-24.04-standard_24.04-2_amd64.tar.zst
```

Default URL:

```text
https://download.proxmox.com/images/system/ubuntu-24.04-standard_24.04-2_amd64.tar.zst
```

The downloaded template is then passed directly to the LXC resource:

```hcl
operating_system {
  template_file_id = proxmox_download_file.lxc_template.id
  type             = var.operating_system
}
```

This ensures Terraform creates the template dependency before attempting to create the container.

> **Storage note:** Proxmox template files must be stored on a datastore supporting the `vztmpl` content type. LXC root disks and templates may therefore require separate Proxmox datastores.

## Networking

The container uses DHCP by default:

```hcl
ip_config {
  ipv4 {
    address = "dhcp"
  }
}
```

The default Proxmox bridge is:

```text
vmbr0
```

The network interface name can be configured with:

```hcl
network_interface_name = "eth0"
```

## Security

Containers are unprivileged by default:

```hcl
unprivileged = true
```

This provides stronger isolation between the LXC container and the Proxmox host.

For workloads requiring nested container functionality, such as Docker:

```hcl
enable_nesting = true
```

## Inputs

| Name | Description | Type | Default |
|---|---|---|---|
| `vm_id` | Unique Proxmox CT ID | `number` | Required |
| `hostname` | LXC hostname | `string` | Required |
| `description` | Description shown in Proxmox | `string` | `Terraform-provisioned LXC container` |
| `tags` | Proxmox tags | `list(string)` | `["terraform", "lxc"]` |
| `node_name` | Proxmox node | `string` | `"pve"` |
| `datastore_id` | Datastore used by the module | `string` | `"local-lvm"` |
| `operating_system` | LXC operating-system type | `string` | `"ubuntu"` |
| `template_url` | URL of the LXC template | `string` | Ubuntu 24.04 template |
| `cpu` | Number of CPU cores | `number` | `2` |
| `memory` | Memory in MB | `number` | `2048` |
| `swap` | Swap in MB | `number` | `512` |
| `disk_size` | Root filesystem size in GB | `number` | `8` |
| `started` | Start container after creation | `bool` | `true` |
| `start_on_boot` | Start container when Proxmox boots | `bool` | `true` |
| `unprivileged` | Run as an unprivileged LXC | `bool` | `true` |
| `enable_nesting` | Enable nested container functionality | `bool` | `false` |
| `network_bridge` | Proxmox network bridge | `string` | `"vmbr0"` |
| `network_interface_name` | LXC network interface name | `string` | `"eth0"` |
| `dns_domain` | DNS search domain | `string` | `""` |
| `dns_servers` | DNS servers | `list(string)` | `[]` |
| `ssh_authorized_keys` | SSH public keys for the container | `list(string)` | `[]` |

## Outputs

| Name | Description |
|---|---|
| `ipv4` | IPv4 addresses assigned to LXC network interfaces |
| `vm_id` | Proxmox CT ID |
| `hostname` | LXC hostname |
| `node_name` | Proxmox node hosting the container |

Example:

```hcl
output "test_lxc_ip" {
  value = module.lxc.ipv4
}
```

## Example Test LXC

This module can be used to provision a dedicated Test LXC container:

```text
Proxmox
└── test-lxc
    ├── Ubuntu 24.04
    ├── 2 vCPU
    ├── 4 GB RAM
    ├── 2 GB Swap
    ├── 40 GB Root Disk
    ├── DHCP
    └── LXC Nesting Enabled
```

## Development

Format Terraform files:

```bash
terraform fmt -recursive
```

Initialize providers and modules:

```bash
terraform init
```

Validate configuration:

```bash
terraform validate
```

Review infrastructure changes:

```bash
terraform plan
```

Apply only after reviewing the Terraform plan:

```bash
terraform apply
```

## References

- `bpg/proxmox` Terraform Provider
- `proxmox_virtual_environment_container`
- `proxmox_download_file`
- Proxmox VE LXC documentation
