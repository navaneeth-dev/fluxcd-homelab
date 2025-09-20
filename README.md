<div align="center">

# FluxCD Homelab

4<sup>th</sup> edition of my homelab in a monorepo, completely GitOps driven.

</div>


<div align="center">

[![Kubernetes](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.raspbernetes.com%2Fkubernetes_version&style=for-the-badge&logo=kubernetes&logoColor=white&color=blue)](https://kubernetes.io/)
&nbsp;&nbsp;
[![Talos](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.raspbernetes.com%2Ftalos_version&style=for-the-badge&logo=talos&logoColor=white&color=blue)](https://talos.dev)
&nbsp;&nbsp;
[![FluxCD](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.raspbernetes.com%2Fflux_version&style=for-the-badge&logo=flux&logoColor=white&color=blue)](https://fluxcd.io/)
&nbsp;&nbsp;

</div>

<div align="center">

![Jellyfin](https://cronitor.io/badges/fM5CuI/production/mO5x8nd7p3CaNIfguz368Gkn-IM.svg)&nbsp;&nbsp;
[![Age-Days](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.raspbernetes.com%2Fcluster_age_days&style=flat-square&label=Age)](https://github.com/kashalls/kromgo)
&nbsp;&nbsp;
[![Uptime-Days](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.raspbernetes.com%2Fcluster_uptime_days&style=flat-square&label=Uptime)](https://github.com/kashalls/kromgo)
&nbsp;&nbsp;
[![Node-Count](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.raspbernetes.com%2Fcluster_node_count&style=flat-square&label=Nodes)](https://github.com/kashalls/kromgo)
&nbsp;&nbsp;
[![Pod-Count](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.raspbernetes.com%2Fcluster_pod_count&style=flat-square&label=Pods)](https://github.com/kashalls/kromgo)
&nbsp;&nbsp;
[![CPU-Usage](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.raspbernetes.com%2Fcluster_cpu_usage&style=flat-square&label=CPU)](https://github.com/kashalls/kromgo)
&nbsp;&nbsp;
[![Memory-Usage](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.raspbernetes.com%2Fcluster_memory_usage&style=flat-square&label=Memory)](https://github.com/kashalls/kromgo)
&nbsp;&nbsp;

</div>

## 🖥️ Technology Stack

|                                                                                                                                      | Name                                           | Description                                                                                                                   |
|--------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------|
| <img width="32" src="https://raw.githubusercontent.com/openwrt/branding/refs/heads/master/logo/openwrt_logo_blue_and_dark_blue.svg"> | [OpenWRT](https://kubernetes.io/)              | The OpenWrt Project is a Linux operating system targeting embedded devices                                                    |
| <img width="32" src="https://github.com/cncf/artwork/raw/main/projects/kubernetes/icon/color/kubernetes-icon-color.svg">             | [Kubernetes](https://kubernetes.io/)           | An open-source system for automating deployment, scaling, and management of containerized applications                        |
| <img width="32" src="https://github.com/cncf/artwork/raw/main/projects/flux/icon/color/flux-icon-color.svg">                         | [FluxCD](https://fluxcd.io/)                   | GitOps tool for deploying applications to Kubernetes                                                                          |
| <img width="32" src="https://www.talos.dev/images/logo.svg">                                                                         | [Talos Linux](https://www.talos.dev/)          | Talos Linux is Linux designed for Kubernetes                                                                                  |
| <img width="62" src="https://github.com/cncf/artwork/raw/main/projects/cilium/icon/color/cilium_icon-color.svg">                     | [Cilium](https://cilium.io/)                   | Cilium is an open source, cloud native solution for providing, securing, and observing network connectivity between workloads |
| <img width="32" src="https://github.com/cncf/artwork/raw/main/projects/containerd/icon/color/containerd-icon-color.svg">             | [containerd](https://containerd.io/)           | Container runtime integrated with Talos Linux                                                                                 |
| <img width="32" src="https://github.com/cncf/artwork/raw/main/projects/coredns/icon/color/coredns-icon-color.svg">                   | [CoreDNS](https://coredns.io/)                 | A DNS server that operates via chained plugins                                                                                |
| <img width="32" src="https://metallb.universe.tf/images/logo/metallb-blue.png">                                                      | [MetalLB](https://metallb.universe.tf/)        | Load-balancer implementation for bare metal Kubernetes clusters, using standard routing protocols                             |
| <img width="32" src="https://github.com/cncf/artwork/raw/main/projects/helm/icon/color/helm-icon-color.svg">                         | [Helm](https://helm.sh)                        | The Kubernetes package manager                                                                                                |
| <img width="32" src="https://github.com/cncf/artwork/raw/main/projects/cert-manager/icon/color/cert-manager-icon-color.svg">         | [Cert Manager](https://cert-manager.io/)       | X.509 certificate management for Kubernetes                                                                                   |
| <img width="32" src="https://grafana.com/static/img/menu/grafana2.svg">                                                              | [Grafana](https://grafana.com)                 | Analytics & monitoring solution for every database                                                                            |
| <img width="62" src="https://raw.githubusercontent.com/navaneeth-dev/fluxcd-homelab/refs/heads/main/.github/assets/vm.jpg">          | [VictoriaMetrics](https://victoriametrics.com) | Open source metrics and logging storage                                                                                       |
| <img width="62" src="https://velero.io/img/Velero.svg">                                                                              | [Velero](https://velero.io/)                   | Backup and restore, perform disaster recovery, and migrate Kubernetes cluster resources and persistent volumes                |

## ⚙ Hardware

### Networking / Misc

| Device                         | OS          | Function               |
|--------------------------------|-------------|------------------------|
| TP-Link Omanda Switch SG3210   | Proprietary | 1GbE Switch            |
| MI 4A Gigabit Access Point     | OpenWRT     | 1GbE Access Point      |
| NanoPi R2S                     | OpenWRT     | 1GbE Firewall & Router |
| APC BX1100C-IN 1100VA Back UPS | -           | UPS                    |
| APC Inverter                   | -           | Invertor               |

### Servers

| Device                    | OS      | RAM       | Storage              | Function |
|---------------------------|---------|-----------|----------------------|----------|
| Custom Built              | Proxmox | 16GB DDR4 | 500GB NVMe           | Node1    |
| ThinkCentre Neo 50s Gen 5 | Proxmox | 16GB DDR5 | 1TB NVMe             | Node2    |
| HP G4 600 SFF             | Proxmox | 32GB DDR4 | 500GB NVMe + 8TB HDD | Node3    |

## 🤖 Updates

This repository is automatically managed by [Renovate](https://renovatebot.com/). Renovate will keep all of the
container images within this repository up to date automatically. It can also be configured to keep Helm chart
dependencies up to date as well.

## 📜 Philosophy

- Update monthly to balance security, uptime and time
- Support IPv6 (Coming soon)
- Testing via Actions (Coming soon)
- DRY
- 100% IaC so that it can be recreated in the event of disaster recovery
- Monitoring and alerting
