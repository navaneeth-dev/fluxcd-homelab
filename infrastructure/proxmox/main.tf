variable "nodes" {
  type = map(string)
  default = {
    thinkcentre = "pve-thinkcentre"
    minipc      = "pve-minipc"
    pve         = "pve"
  }
}

variable "node_vm_offsets" {
  type = map(number)
  default = {
    thinkcentre = 5000
    minipc      = 6100
    pve         = 8000
  }
}

# Download Talos ISO on every node
resource "proxmox_virtual_environment_download_file" "talos_iso" {
  for_each     = var.nodes
  content_type = "iso"
  datastore_id = "local"
  node_name    = each.value
  url          = "https://factory.talos.dev/image/583560d413df7502f15f3c274c36fc23ce1af48cef89e98b1e563fb49127606e/v1.11.1/nocloud-amd64.iso"
  file_name    = "talos.iso"
}

# Controlplane VMs
resource "proxmox_virtual_environment_vm" "controlplane" {
  for_each  = var.nodes
  name      = "controlplane-${each.key}"
  node_name = each.value
  vm_id     = var.node_vm_offsets[each.key] + 1
  boot_order = ["virtio0", "ide3"]

  agent { enabled = true }

  cpu {
    cores = 2
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = 4096
    floating  = 4096
  }

  network_device { enabled = true }

  cdrom {
    file_id = proxmox_virtual_environment_download_file.talos_iso[each.key].id
  }

  serial_device {}

  disk {
    datastore_id = "local-lvm"
    interface    = "virtio0"
    discard      = "on"
    ssd          = true
    size         = 32
  }
}

# Worker VMs
resource "proxmox_virtual_environment_vm" "worker" {
  for_each  = var.nodes
  name      = "worker-${each.key}"
  node_name = each.value
  vm_id     = var.node_vm_offsets[each.key] + 2
  boot_order = ["virtio0", "ide3"]

  agent { enabled = true }

  serial_device {}

  cpu {
    cores = 4
    type = "x86-64-v2-AES"
  }

  memory {
    dedicated = 8192
    floating  = 8192
  }

  network_device { enabled = true }

  cdrom {
    file_id = proxmox_virtual_environment_download_file.talos_iso[each.key].id
  }

  hostpci {
    device = "hostpci0"
    id     = "0000:00:02.0"
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "virtio0"
    discard      = "on"
    ssd          = true
    size         = 60
  }
}
