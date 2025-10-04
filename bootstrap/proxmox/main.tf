resource "proxmox_virtual_environment_vm" "controlplane" {
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

  hostpci {
    device = "hostpci0"
    id = "00:02.0"
  }

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

  # initialization {
  #   ip_config {
  #     ipv4 {
  #       address = "${cidrhost(local.ipv4.prefix, count.index+2)}/24"
  #       gateway = local.ipv4.gateway
  #     }
  #     ipv6 {
  #       # address = "dhcp"
  #       address = "${cidrhost(local.ipv6.prefix, count.index+2)}/64"
  #       gateway = local.ipv6.gateway
  #     }
  #   }
  #
  #   dns {
  #     domain = ""
  #     servers = ["192.168.2.1"]
  #   }
  # }

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
