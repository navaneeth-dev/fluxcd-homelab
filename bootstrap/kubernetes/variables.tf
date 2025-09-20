locals {
  nodes = [
    "pve",
    "pve-minipc",
    "pve-thinkcentre",
  ]
}

variable "proxmox_endpoint" {
  description = "Proxmox endpoint"
}