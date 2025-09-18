resource "proxmox_virtual_environment_vm" "talos4" {
  name      = "talos4"
  node_name = "pve-thinkcentre"
  vm_id = "5000"
  boot_order = ["virtio0", "ide3"]

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

resource "proxmox_virtual_environment_vm" "worker-thinkcentre" {
  name      = "worker-thinkcentre"
  node_name = "pve-thinkcentre"
  vm_id = "5001"

  agent {
    enabled = true
  }

  cpu {
    cores = 4
    type = "host"
  }

  memory {
    dedicated = 8192
    floating = 8192
  }

  network_device {
    enabled = true
  }

  boot_order = ["virtio0", "ide3"]

  cdrom {
    file_id = proxmox_virtual_environment_download_file.talos_iso.id
  }

  hostpci {
    device = "hostpci0"
    id = "0000:00:02.0"
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "virtio0"
    discard      = "on"
    ssd = true
    size         = 60
  }
}

resource "proxmox_virtual_environment_download_file" "talos_iso" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "pve-thinkcentre"
  url          = "https://factory.talos.dev/image/583560d413df7502f15f3c274c36fc23ce1af48cef89e98b1e563fb49127606e/v1.11.1/nocloud-amd64.iso"
  file_name = "talos.iso"
}