locals {
  nodes = [
    "pve",
    "pve-minipc",
    "pve-thinkcentre",
  ]

  ipv4 = {
    prefix = "192.168.3.0/24"
    gateway = "192.168.3.1"
  }

  vlan_id = 2

  protection = true
}

variable "proxmox_endpoint" {
  description = "Proxmox endpoint"
}