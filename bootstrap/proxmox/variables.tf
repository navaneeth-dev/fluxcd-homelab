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

  ipv6 = {
    prefix = "fd47:6ac8:e64c::/64"
    gateway = "fd47:6ac8:e64c::1"
  }

  vlan_id = 2

  protection = false
}

variable "proxmox_endpoint" {
  description = "Proxmox endpoint"
}

variable "CF_DNS_API_TOKEN" {
  sensitive = true
}