# create-cluster role

This role initializes one kubeadm control plane, installs the Calico CNI, and
publishes short-lived worker bootstrap credentials through the dynamic
`K8S_TOKEN_HOLDER` host. Initialization is guarded by
`/etc/kubernetes/admin.conf`, so re-running the playbook does not reset an
existing control plane.

## Variables

- `kubeadm_advertise_address`: Address advertised by the API server.
- `kubernetes_control_plane_endpoint`: Address workers use to reach the API.
- `kubernetes_api_port`: Kubernetes API port, default `6443`.
- `kubernetes_pod_network_cidr`: Pod CIDR passed to kubeadm, default
  `192.168.0.0/16`.
- `kubernetes_cni_manifest_url`: Calico manifest URL.
- `kubeadm_token_ttl`: Lifetime of the worker token, default `24h`.
- `kubeadm_init_extra_args`: Additional kubeadm init arguments as a list.

The role expects `ansible_user` to identify the SSH user whose kubeconfig is
created. It does not perform a destructive `kubeadm reset`.
