# resource "proxmox_virtual_environment_vm" "test" {
#   name       = "debiantest"
#   node_name  = local.nodes[1]
#   boot_order = ["virtio0", "ide3"]
#   protection = local.protection
#   tags = ["test"]
#   vm_id = 169
#
#   agent { enabled = true }
#
#   cpu {
#     cores = 1
#     type  = "x86-64-v2-AES"
#   }
#
#   memory {
#     dedicated = 2048
#     floating  = 2048
#   }
#
#   network_device {
#     enabled = true
#     vlan_id = local.vlan_id
#   }
#
#   serial_device {}
#
#   initialization {
#     user_data_file_id = proxmox_virtual_environment_file.cloud_init_config[1].id
#     ip_config {
#       ipv4 {
#         address = "192.168.3.70/24"
#         gateway = local.ipv4.gateway
#       }
#       ipv6 {
#         address = "dhcp"
#       }
#     }
#   }
#
#   disk {
#     datastore_id = "local-lvm"
#     import_from = proxmox_virtual_environment_download_file.debian_cloud_image[1].id
#     file_format  = "raw"
#     interface    = "virtio0"
#     discard      = "on"
#     ssd          = false
#     size         = 24
#   }
# }
