resource "proxmox_virtual_environment_vm" "omni" {
  name       = "omni"
  node_name  = local.nodes[1]
  vm_id      = 5531
  boot_order = ["virtio0", "ide3"]
  protection = local.protection
  tags = ["k8s", "omni"]

  agent { enabled = true }
  machine = "q35"
  bios = "ovmf"
  efi_disk {}

  cpu {
    cores = 1
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = 2048
    floating  = 2048
  }

  network_device {
    enabled = true
    vlan_id = local.vlan_id
  }

  serial_device {}

  initialization {
    user_data_file_id = proxmox_virtual_environment_file.omni_ignition.id
    ip_config {
      ipv4 {
        address = "dhcp"
        # address = "192.168.3.69/24"
        # gateway = local.ipv4.gateway
      }
      ipv6 {
        address = "dhcp"
        # address = "${cidrhost(local.ipv6.prefix, 15)}/64"
        # gateway = local.ipv6.gateway
      }
    }
  }

  disk {
    datastore_id = "local-lvm"
    import_from = proxmox_virtual_environment_download_file.flatcar_cloud_image.id
    file_format  = "raw"
    interface    = "virtio0"
    discard      = "on"
    ssd          = false
    size         = 32
  }
}

resource "proxmox_virtual_environment_file" "omni_ignition" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = local.nodes[1]

  source_raw {
    data = data.ct_config.machine-ignition.rendered
    file_name = "omni.ign"
  }
}

data "ct_config" "machine-ignition" {
  content = data.template_file.machine-cl-config.rendered
  strict = true
}

data "template_file" "machine-cl-config" {
  template = file("${path.module}/templates/matchbox.bu.tftpl")
}

resource "proxmox_virtual_environment_download_file" "flatcar_cloud_image" {
  content_type = "import"
  datastore_id = "local"
  node_name    = local.nodes[1]
  url          = "https://stable.release.flatcar-linux.net/amd64-usr/current/flatcar_production_proxmoxve_image.img"
  file_name    = "flarcar.qcow2"
}
