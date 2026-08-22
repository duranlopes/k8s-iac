# install-helm role

This role installs Helm from the official signed Helm apt repository. The
repository key is stored under `/etc/apt/keyrings` and referenced with
`signed-by`; it does not use the deprecated `apt_key` module.

## Variables

- `helm_apt_key_url`: Helm repository signing-key URL.
- `helm_apt_keyring_path`: Keyring path, default `/etc/apt/keyrings/helm.asc`.
- `helm_apt_repository`: Signed Helm apt repository definition.
- `helm_package_name`: Package name, default `helm`.
