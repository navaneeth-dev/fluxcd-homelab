resource "proxmox_virtual_environment_vm" "controlplane" {
  depends_on = [proxmox_virtual_environment_vm.omni]

  count = length(local.nodes)

  name       = "controlplane-${local.nodes[count.index]}"
  node_name  = local.nodes[count.index]
  vm_id      = 4300 + count.index
  boot_order = ["virtio0", "net0"]
  protection = local.protection
  tags = ["k8s", "controlplane"]

  agent { enabled = true }
  machine = "q35"
  bios = "ovmf"
  efi_disk {}

  # hostpci {
  #   device = "hostpci0"
  #   id = "00:02.0"
  # }

  cpu {
    cores = 4
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = 12288
    floating  = 12288
  }

  network_device {
    enabled = true
    vlan_id = local.vlan_id
  }

  serial_device {}

  initialization {
    user_data_file_id = proxmox_virtual_environment_file.talos_config[count.index].id
    ip_config {
      ipv4 {
        address = "${cidrhost(local.ipv4.prefix, count.index+2)}/24"
        gateway = local.ipv4.gateway
      }
      ipv6 {
        # address = "dhcp"
        address = "${cidrhost(local.ipv6.prefix, count.index+2)}/64"
        gateway = local.ipv6.gateway
      }
    }

    dns {
      servers = [local.ipv4.gateway]
    }
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "virtio0"
    discard      = "on"
    ssd          = false
    size         = 32
  }

  # rook ceph
  disk {
    datastore_id = "local-lvm"
    interface    = "virtio1"
    discard      = "on"
    size         = 64
  }
}

resource "proxmox_virtual_environment_file" "talos_config" {
  count = length(local.nodes)

  content_type = "snippets"
  datastore_id = "local"
  node_name    = local.nodes[count.index]

  source_file {
    path = "${path.module}/../talos/clusterconfig/home-cluster-controlplane-${local.nodes[count.index]}.yaml"
  }
}