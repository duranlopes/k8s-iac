# install-k8s role

This role prepares Debian-family hosts for a kubeadm cluster. It disables swap,
loads the kernel modules required by Kubernetes, configures forwarding sysctls,
installs containerd as the CRI, and installs kubelet, kubeadm, and kubectl from
the official `pkgs.k8s.io` repository.

## Requirements

- A Debian-family operating system with systemd.
- SSH access for the user in `ansible_user` and passwordless sudo.
- Ansible collections listed in `iac/ansible/requirements.yml`.

## Variables

- `kubernetes_minor_version`: Kubernetes package stream, default `1.30`.
- `kubernetes_apt_key_url`: Repository signing-key URL.
- `kubernetes_apt_repository`: Repository definition using `signed-by`.
- `kubernetes_packages`: Packages installed on every node.
- `kubernetes_pause_image`: Pause image configured for containerd.

The role intentionally does not modify network interfaces, add SSH keys, or
rewrite netplan files. Cloud-init, Terraform, or an operator-owned network
configuration should provide node connectivity before this role runs.
