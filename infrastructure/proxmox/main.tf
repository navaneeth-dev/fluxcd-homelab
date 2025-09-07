resource "proxmox_virtual_environment_vm" "nas2_vm" {
  name      = "nas2"
  node_name = "pve"
  vm_id = "100"

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
    # size         = 20
  }

  disk {
    interface = "virtio1"
    datastore_id = ""
    path_in_datastore  = "/dev/disk/by-id/nvme-WD_Blue_SN570_500GB_SSD_23196K805535"
    file_format = "raw"
  }

  disk {
    interface = "virtio2"
    datastore_id = ""
    path_in_datastore  = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_500GB_S4EVNM0R224774V-part4"
    file_format = "raw"
  }

  initialization {
    user_data_file_id = proxmox_virtual_environment_file.ignition_config.id
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

resource "proxmox_virtual_environment_file" "ignition_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "pve"

  source_file {
    path = "files/nas.ign"
  }
}