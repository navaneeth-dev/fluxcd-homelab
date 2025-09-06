resource "proxmox_virtual_environment_vm" "nas2_vm" {
  name      = "nas2"
  node_name = "pve"

  agent {
    enabled = true
  }

  cpu {
    cores = 1
    type = "host"
  }

  memory {
    dedicated = 2048
    floating = 2048
  }

  network_device {
    enabled = true
  }

  disk {
    datastore_id = "local-lvm"
    import_from  = "local:import/flatcar_custom.qcow2"
    file_format = "qcow2"
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    ssd = true
    size         = 20
  }

  initialization {
    user_data_file_id = proxmox_virtual_environment_file.coreos_config.id
    ip_config {
      ipv4 {
        address = "192.168.2.9/24"
        gateway = "192.168.2.1"
      }
      ipv6 {
        address = "dhcp"
      }
    }
  }
}

resource "proxmox_virtual_environment_file" "coreos_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "pve"

  source_file {
    path = "files/config.ign"
  }
}