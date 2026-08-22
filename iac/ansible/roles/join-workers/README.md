# join-workers role

This role joins workers to the kubeadm cluster using credentials published by
the control plane through the dynamic `K8S_TOKEN_HOLDER` host. It checks for
`/etc/kubernetes/kubelet.conf` before running `kubeadm join` and never resets a
worker automatically.

## Variables

- `kubernetes_api_port`: API port used when a control plane publishes
  credentials, default `6443`.
- `kubeadm_join_extra_args`: Additional kubeadm join arguments as a list.

The role is normally used after `create-cluster` in the repository playbook.
If a worker has stale kubeadm state but no kubelet configuration, clean it
manually and rerun the playbook rather than relying on a destructive task.
