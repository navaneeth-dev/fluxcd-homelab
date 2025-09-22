resource "proxmox_virtual_environment_download_file" "debian_cloud_image" {
  count = length(local.nodes)

  content_type = "import"
  datastore_id = "local"
  node_name    = local.nodes[count.index]
  url          = "https://cdimage.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2"
  file_name    = "debian-12-generic-amd64.qcow2"
}

# resource "proxmox_virtual_environment_file" "ignition_config" {
#   count = length(local.nodes)
#
#   content_type = "snippets"
#   datastore_id = "local"
#   node_name    = local.nodes[count.index]
#
#   source_raw {
#     file_name = "config.ign"
#     data = data.ct_config.machine-ignition[count.index].rendered
#   }
# }

resource "proxmox_virtual_environment_file" "cloud_init_config" {
  count = length(local.nodes)

  content_type = "snippets"
  datastore_id = "local"
  node_name    = local.nodes[count.index]

  source_raw {
    data = <<-EOF
    #cloud-config
    package_reboot_if_required: true
    package_update: true
    package_upgrade: true
    hostname: ${local.nodes[count.index]}
    packages:
      - qemu-guest-agent
      - neovim
      - software-properties-common
    users:
      - name: rize
        groups: sudo
        shell: /bin/bash
        ssh-authorized-keys:
          - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICiUB1MgFciQ63LsGGBwHVjCtf1cn50BdxN9jTtfTPGF rize@legion
        sudo: ALL=(ALL) NOPASSWD:ALL
    runcmd:
      - reboot
    EOF

    file_name = "${local.nodes[count.index]}.cloud-config.yaml"
  }
}

resource "proxmox_virtual_environment_vm" "controlplane" {
  count = length(local.nodes)

  name      = "controlplane-${local.nodes[count.index]}"
  node_name = local.nodes[count.index]
  vm_id     = 4300 + count.index
  boot_order = ["virtio0", "ide3"]
  protection = false

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

  serial_device {}

  initialization {
    user_data_file_id = proxmox_virtual_environment_file.cloud_init_config[count.index].id
    ip_config {
      ipv4 {
        address = "192.168.2.3${count.index}/24"
        gateway = "192.168.2.1"
      }
      ipv6 {
        address = "dhcp"
      }
    }
  }

  disk {
    datastore_id = "local-lvm"
    import_from  = proxmox_virtual_environment_download_file.debian_cloud_image[count.index].id
    # import_from = "local:import/flatcar.qcow2"
    file_format  = "raw"
    interface    = "virtio0"
    discard      = "on"
    ssd          = false
    size         = 32
  }
}

# Worker VMs
# resource "proxmox_virtual_environment_vm" "worker" {
#   for_each  = var.nodes
#   name      = "worker-${each.key}"
#   node_name = each.value
#   vm_id     = var.node_vm_offsets[each.key] + 2
#   boot_order = ["virtio0", "ide3"]
#
#   agent { enabled = true }
#
#   serial_device {}
#
#   cpu {
#     cores = 4
#     type = "x86-64-v2-AES"
#   }
#
#   memory {
#     dedicated = 8192
#     floating  = 8192
#   }
#
#   network_device { enabled = true }
#
#   cdrom {
#     file_id = proxmox_virtual_environment_download_file.talos_iso[each.key].id
#   }
#
#   hostpci {
#     device = "hostpci0"
#     id     = "0000:00:02.0"
#   }
#
#   disk {
#     datastore_id = "local-lvm"
#     interface    = "virtio0"
#     discard      = "on"
#     ssd          = true
#     size         = 60
#   }
# }

data "ct_config" "machine-ignition" {
  count = length(local.nodes)

  content = data.template_file.machine-cl-config[count.index].rendered
}

data "template_file" "machine-cl-config" {
  count = length(local.nodes)

  template = file("${path.module}/templates/config.yaml.tmpl")
  vars = { hostname = local.nodes[count.index] }
}