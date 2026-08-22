# k8s-features role

This role installs cluster add-ons with the `kubernetes.core` collection:

- ingress-nginx with a configurable service type, default `NodePort`;
- metrics-server in `kube-system`; and
- kube-prometheus-stack in the `monitoring` namespace.

It uses Helm repositories and releases instead of copying manifests from
outside the role or invoking `kubectl` through shell commands.

## Variables

- `kubernetes_kubeconfig`: Control-plane kubeconfig path.
- `k8s_features_helm_repositories`: Helm repositories to register.
- `ingress_namespace`, `ingress_release_name`, `ingress_chart`, and
  `ingress_service_type`: ingress settings.
- `metrics_namespace`, `metrics_release_name`, and `metrics_chart`:
  metrics-server settings.
- `monitoring_namespace`, `monitoring_release_name`, and `monitoring_chart`:
  Prometheus stack settings.
