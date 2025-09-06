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
      "192.168.2.131" = {
        install_disk = "/dev/sda"
        hostname     = "talos1"
      },
      "192.168.2.128" = {
        install_disk = "/dev/sda"
        hostname     = "talos2"
      },
      "192.168.2.184" = {
        install_disk = "/dev/sda"
        hostname     = "talos3"
      },
    }
    workers = {
      "192.168.2.138" = {
        install_disk = "/dev/sda"
        hostname     = "talos-worker1"
      },
      "192.168.2.221" = {
        install_disk = "/dev/sda"
        hostname     = "talos-worker2"
      }
    }
  }
}
