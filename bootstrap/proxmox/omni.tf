resource "proxmox_virtual_environment_vm" "omni" {
  name       = "omni"
  node_name  = "pve-minipc"
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
    user_data_file_id = proxmox_virtual_environment_file.omni_cloud_init.id
    ip_config {
      ipv4 {
        address = "192.168.3.69/24"
        gateway = local.ipv4.gateway
      }
      ipv6 {
        # address = "dhcp"
        address = "${cidrhost(local.ipv6.prefix, 15)}/64"
        gateway = local.ipv6.gateway
      }
    }
  }

  disk {
    datastore_id = "local-lvm"
    import_from = proxmox_virtual_environment_download_file.debian_cloud_image[1].id
    file_format  = "raw"
    interface    = "virtio0"
    discard      = "on"
    ssd          = false
    size         = 32
  }
}

resource "proxmox_virtual_environment_file" "omni_cloud_init" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = local.nodes[1]

  source_raw {
    data = <<-EOF
    #cloud-config
    package_reboot_if_required: true
    package_update: true
    package_upgrade: true
    hostname: omni
    packages:
      - qemu-guest-agent
      - neovim
      - software-properties-common
    users:
      - name: default
        ssh_authorized_keys:
          - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICiUB1MgFciQ63LsGGBwHVjCtf1cn50BdxN9jTtfTPGF rize@legion
    runcmd:
      - reboot
    EOF

    file_name = "omni.cloud-config.yaml"
  }
}
