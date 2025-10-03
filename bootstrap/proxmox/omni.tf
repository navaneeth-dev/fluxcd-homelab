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

  vga {
    type = "serial0"
  }

  initialization {
    user_data_file_id = proxmox_virtual_environment_file.omni_ignition.id
    ip_config {
      ipv4 {
        address = "dhcp"
      }
      ipv6 {
        address = "dhcp"
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
    size         = 12
  }

  dynamic "disk" {
    for_each = { for idx, val in proxmox_virtual_environment_vm.data_vm.disk : idx => val }
    iterator = data_disk
    content {
      datastore_id      = data_disk.value["datastore_id"]
      path_in_datastore = data_disk.value["path_in_datastore"]
      file_format       = data_disk.value["file_format"]
      size              = data_disk.value["size"]
      interface         = "virtio${data_disk.key + 1}"
    }
  }
}

resource "proxmox_virtual_environment_vm" "data_vm" {
  name = "omni-data"
  description = "DO NOT DELETE"
  node_name = local.nodes[1]
  started = false
  on_boot = false

  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         = 1
  }

  lifecycle {
    prevent_destroy = true
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
  vars = {
    INFISICAL_CLIENT_SECRET = var.INFISICAL_TOKEN
    OMNI_DOMAIN_NAME = "omni.fossindia.ovh"
    OMNI_ADMIN_EMAIL = "me@rizexor.com"
    AUTH0_DOMAIN = "dev-pdtgsnqj.eu.auth0.com"
    AUTH0_CLIENT_ID = "EXGbxvfNmk1s0Kw27K2pX0FEOkvGBy85"
    OMNI_WG_IP = "192.168.3.69"
  }
}

resource "proxmox_virtual_environment_download_file" "flatcar_cloud_image" {
  content_type = "import"
  datastore_id = "local"
  node_name    = local.nodes[1]
  url          = "https://stable.release.flatcar-linux.net/amd64-usr/current/flatcar_production_proxmoxve_image.img"
  file_name    = "flarcar.qcow2"
}
