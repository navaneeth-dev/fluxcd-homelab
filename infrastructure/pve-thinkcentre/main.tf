resource "proxmox_virtual_environment_vm" "talos4" {
  name      = "nas2"
  node_name = "pve-thinkcentre"
  vm_id = "5000"

  agent {
    enabled = true
  }

  cpu {
    cores = 2
    type = "host"
  }

  memory {
    dedicated = 4096
    floating = 4096
  }

  network_device {
    enabled = true
  }

  cdrom {
    file_id = proxmox_virtual_environment_download_file.talos_iso.id
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "virtio0"
    discard      = "on"
    ssd = true
    size         = 32
  }
}

resource "proxmox_virtual_environment_download_file" "talos_iso" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "pve-thinkcentre"
  url          = "https://factory.talos.dev/image/d3dc673627e9b94c6cd4122289aa52c2484cddb31017ae21b75309846e257d30/v1.10.7/nocloud-amd64.iso"
  file_name = "talos.iso"
}