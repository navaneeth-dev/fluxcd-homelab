variable "cluster_name" {
  description = "A name to provide for the Talos cluster"
  type        = string
}

variable "cluster_endpoint" {
  description = "The endpoint for the Talos cluster"
  type        = string
}

variable "SOPS_AGEKEY" {
  description = "SOPS age private key"
  sensitive = true
}

variable "node_data" {
  description = "A map of node data"
  type = object({
    controlplanes = map(object({
      install_disk = string
      hostname     = optional(string)
    }))
    workers = map(object({
      install_disk = string
      hostname     = optional(string)
    }))
  })
  default = {
    controlplanes = {
      "192.168.2.139" = {
        install_disk = "/dev/vda"
        hostname     = "controlplane-pve"
      },
      "192.168.2.159" = {
        install_disk = "/dev/vda"
        hostname     = "controlplane-minipc"
      },
      "192.168.2.190" = {
        install_disk = "/dev/vda"
        hostname     = "controlplane-thinkcentre"
      },
    }
    workers = {
      "192.168.2.149" = {
        install_disk = "/dev/vda"
        hostname     = "worker-pve"
      },
      "192.168.2.225" = {
        install_disk = "/dev/vda"
        hostname     = "worker-minipc"
      }
      "192.168.2.218" = {
        install_disk = "/dev/vda"
        hostname     = "worker-thinkcentre"
      }
    }
  }
}
