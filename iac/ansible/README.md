# Ansible Kubernetes bootstrap

This directory bootstraps a kubeadm Kubernetes cluster on Debian-family hosts.
Terraform provisions the instances and writes their addresses under
`iac/address/`; Ansible consumes a locally generated inventory containing those
addresses.

## Roles

1. `install-k8s` installs containerd, kubelet, kubeadm, and kubectl from the
   official `pkgs.k8s.io` repository. It does not install Docker or rewrite
   network configuration.
2. `create-cluster` runs `kubeadm init` only when
   `/etc/kubernetes/admin.conf` is absent and installs Calico networking.
3. `join-workers` runs `kubeadm join` only when a worker has not already joined.
4. `install-helm` installs Helm from the signed Helm apt repository.
5. `k8s-features` installs ingress-nginx, metrics-server, and the Prometheus
   community stack using the Kubernetes Ansible collection's Helm modules.

## Controller setup

Use a virtual environment on the Ansible controller:

```bash
cd iac/ansible
python3 -m venv .venv
. .venv/bin/activate
python -m pip install --upgrade pip ansible-core ansible-lint
ansible-galaxy collection install -r requirements.yml
```

The repository includes a modern `ansible.cfg`. It uses automatic remote
interpreter discovery, YAML-formatted output, and `inventory.ini` as the local
inventory path.

## Inventory from Terraform

Copy `inventory.ini.example` to `inventory.ini` and replace the placeholders
with the public and private addresses returned by Terraform. Keep
`kubernetes_control_plane_endpoint` set to the control plane's reachable
private address; workers use the value published by the `K8S_TOKEN_HOLDER`
dynamic host.

The generated inventory is intentionally local-only and should not be
committed. A typical workflow is:

```bash
terraform -chdir=iac/terraform output -json
cp iac/ansible/inventory.ini.example iac/ansible/inventory.ini
# Fill inventory.ini from the Terraform output before connecting.
```

## Running the playbook

```bash
cd iac/ansible
ansible-playbook main.yml
```

Useful tags are `install`, `cluster`, `control-plane`, `workers`, `helm`, and
`features`. Use `--check` for a preview where supported. The playbook requires
passwordless sudo and network access from the nodes to the Kubernetes, Helm,
Calico, and chart repositories.

## Validation

Run these commands from this directory:

```bash
ansible-lint .
ansible-playbook --syntax-check -i inventory.ini.example main.yml
```

The syntax check validates the example inventory only; it does not connect to
placeholder hosts.
