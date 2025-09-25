resource "proxmox_virtual_environment_download_file" "debian_cloud_image" {
  count = length(local.nodes)

  content_type = "import"
  datastore_id = "local"
  node_name    = local.nodes[count.index]
  url          = "https://cdimage.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2"
  file_name    = "debian-12-generic-amd64.qcow2"
}

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

  name       = "controlplane-${local.nodes[count.index]}"
  node_name  = local.nodes[count.index]
  vm_id      = 4300 + count.index
  boot_order = ["virtio0", "ide3"]
  protection = local.protection
  tags = ["k8s", "controlplane"]

  agent { enabled = true }

  cpu {
    cores = 2
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = 4096
    floating  = 4096
  }

  network_device {
    enabled = true
    vlan_id = local.vlan_id
  }

  serial_device {}

  initialization {
    user_data_file_id = proxmox_virtual_environment_file.cloud_init_config[count.index].id
    ip_config {
      ipv4 {
        address = "${cidrhost(local.ipv4.prefix, count.index+2)}/24"
        gateway = local.ipv4.gateway
      }
      ipv6 {
        address = "dhcp"
        # address = "${cidrhost(local.ipv6.prefix, count.index+2)}/64"
        # gateway = local.ipv6.gateway
      }
    }
  }

  disk {
    datastore_id = "local-lvm"
    import_from = proxmox_virtual_environment_download_file.debian_cloud_image[count.index].id
    # import_from = "local:import/flatcar.qcow2"
    file_format  = "raw"
    interface    = "virtio0"
    discard      = "on"
    ssd          = false
    size         = 32
  }
}

resource "proxmox_virtual_environment_vm" "worker" {
  count = length(local.nodes)

  name       = "worker-${local.nodes[count.index]}"
  node_name  = local.nodes[count.index]
  vm_id      = 4500 + count.index
  boot_order = ["virtio0", "ide3"]
  protection = local.protection
  tags = ["k8s", "worker"]

  agent { enabled = true }

  cpu {
    cores = 3
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = 8192
    floating  = 8192
  }

  network_device {
    enabled = true
    vlan_id = local.vlan_id
  }

  serial_device {}

  initialization {
    user_data_file_id = proxmox_virtual_environment_file.cloud_init_config[count.index].id
    ip_config {
      ipv4 {
        # 10 = Controlplane ip space between worker
        address = "${cidrhost(local.ipv4.prefix, (count.index+2) + 10 + length(local.nodes))}/24"
        gateway = local.ipv4.gateway
      }
      ipv6 {
        address = "dhcp"
        # address = "${cidrhost(local.ipv6.prefix, (count.index+2) + 10 + length(local.nodes))}/64"
        # gateway = local.ipv6.gateway
      }
    }
  }

  disk {
    datastore_id = "local-lvm"
    import_from = proxmox_virtual_environment_download_file.debian_cloud_image[count.index].id
    # import_from = "local:import/flatcar.qcow2"
    file_format  = "raw"
    interface    = "virtio0"
    discard      = "on"
    ssd          = false
    size         = 32
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "virtio1"
    discard      = "on"
    size         = 32
  }
}

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../inventory/inventory.ini"
  content = templatefile("templates/inventory.ini.tftpl", { nodes = local.nodes, ipv4 = local.ipv4 })

  depends_on = [
    proxmox_virtual_environment_vm.controlplane,
    proxmox_virtual_environment_vm.worker
  ]
}