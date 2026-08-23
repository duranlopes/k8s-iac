# k8s-features role

This role installs cluster add-ons with the `kubernetes.core` collection:

- Envoy Gateway (Gateway API implementation) plus the Gateway API standard
  CRDs, and the shared `Gateway`/`HTTPRoute` manifest from `k8s/gateway/`;
- metrics-server in `kube-system`; and
- kube-prometheus-stack in the `monitoring` namespace.

It uses Helm repositories and releases instead of copying manifests from
outside the role or invoking `kubectl` through shell commands.

## Variables

- `kubernetes_kubeconfig`: Control-plane kubeconfig path.
- `k8s_features_helm_repositories`: Helm repositories to register.
- `gateway_api_crds_url`: URL of the Gateway API CRD bundle to apply.
- `envoy_gateway_release_name`, `envoy_gateway_chart`, and
  `envoy_gateway_chart_version`: Envoy Gateway Helm settings.
- `gateway_manifest_path`: path to the shared Gateway API manifest.
- `metrics_namespace`, `metrics_release_name`, and `metrics_chart`:
  metrics-server settings.
- `monitoring_namespace`, `monitoring_release_name`, and `monitoring_chart`:
  Prometheus stack settings.
