# k8s-iac

Kubernetes cluster on AWS provisioned with Terraform, configured with Ansible, and deployed with Helm — built for studying Kubernetes and IaC tooling.

## Repository Layout

```
api/                  # FastAPI demo application (deployed to the cluster)
iac/
  ansible/            # Ansible roles: install-k8s, create-cluster, join-workers, install-helm, k8s-features
  terraform/          # Terraform module: VPC, subnets, security groups, EC2 (master/nodes), ALB
k8s/
  helmcharts/         # Helm charts: simpleapi, db
  manifests/          # Raw Kubernetes manifests
```

## Tooling

This repository uses [mise](https://mise.jdx.dev) to pin the required CLIs:

- terraform
- terraform-docs
- tflint

After installing mise, the tools are provisioned automatically when you `cd` into the repository:

```bash
curl https://mise.run | sh
cd k8s-iac   # mise installs the tools listed in mise.toml
```

## Terraform

The root module wraps `iac/terraform/modules`, which provisions:

- VPC with DNS support
- Two public subnets across two AZs
- Internet gateway and route tables
- Security group for cluster traffic (SSH, HTTP/HTTPS, 6443, NodePorts)
- EC2 instances: 1 control plane + 2 workers (Ubuntu 22.04 LTS, AMI resolved dynamically or via `ami_id`)
- Application Load Balancer targeting the nodes

Required input:

| Variable     | Description                              |
|--------------|------------------------------------------|
| `public_key` | SSH public key material for the key pair |

### Deploy to real AWS

Credentials come from the environment or `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` secrets in GitHub Actions.

```bash
cd iac/terraform
terraform init
terraform plan -var="public_key=$(cat ~/.ssh/id_rsa.pub)"
terraform apply -auto-approve -var="public_key=$(cat ~/.ssh/id_rsa.pub)"
```

Remote state is stored in S3 (bucket `terraform-state-duran`). Adjust the `backend "s3"` block in `main.tf` as needed.

### Test locally with LocalStack

LocalStack emulates AWS APIs so the configuration can be validated without touching real infrastructure.

```bash
cd iac/terraform
docker compose -f docker-compose.localstack.yml up -d --wait
source localstack.env
terraform init -backend=false
terraform plan -var-file=localstack.tfvars.example -var="public_key=$(cat ~/.ssh/id_rsa.pub)"
```

### GitHub Actions

- `terraform-ci.yml` — fmt check, validate, tflint, and a full `terraform plan` against LocalStack on every PR/push touching `iac/terraform/**`
- `deploy.workflow.yaml` — manual deploy to real AWS (`workflow_dispatch`)
- `destroy.workflow.yaml` — manual destroy (`workflow_dispatch`)

## Ansible

Roles are executed from `iac/ansible` against the IPs written by Terraform to `iac/address/`:

- **install-k8s** — Docker + Kubernetes packages
- **create-cluster** — `kubeadm init` on the control plane
- **join-workers** — worker nodes join the cluster
- **install-helm** — Helm bootstrap
- **k8s-features** — ingress controller and cluster add-ons

## License

MIT
