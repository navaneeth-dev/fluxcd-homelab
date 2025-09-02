# CoreOS Configs

Replace all secrets:
- jdownloader.container
- backup.sh

```bash
sudo flatcar-reset --keep-machine-id --keep-paths '/etc/ssh/ssh_host_.*' --ignition-url 'https://raw.githubusercontent.com/navaneeth-dev/fluxcd-homelab/refs/heads/main/coreos/reverse-proxy-oci/proxy.ign?v=19'
sudo systemctl reboot
```