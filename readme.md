<div align="center">

# ☸️ k8s-iac

**Kubernetes cluster on AWS — provisioned with Terraform, configured with Ansible, deployed with Helm.**

[![CI](https://github.com/duranlopes/k8s-iac/actions/workflows/terraform-ci.yml/badge.svg)](https://github.com/duranlopes/k8s-iac/actions/workflows/terraform-ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.6-7B42BC?logo=terraform&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-kubeadm-326CE5?logo=kubernetes&logoColor=white)
![Ansible](https://img.shields.io/badge/Ansible-roles-EE0000?logo=ansible&logoColor=white)
![LocalStack](https://img.shields.io/badge/tested%20with-LocalStack-4E9BCD?logo=docker&logoColor=white)

</div>

---

## 📖 Overview

This repository provisions a complete Kubernetes cluster on AWS using Infrastructure as Code, then configures it and deploys workloads — end to end:

| Stage | Tool | What it does |
|-------|------|--------------|
| 1. Provision | **Terraform** | VPC, subnets, security groups, EC2 (1 control plane + 2 workers), ALB |
| 2. Configure | **Ansible** | Docker + kubeadm install, cluster bootstrap, worker join, Helm |
| 3. Deploy | **Helm** | Demo FastAPI app + database via Helm charts |

Built for studying Kubernetes and modern IaC practices. Every Terraform change is validated in CI against **LocalStack** before it ever touches real AWS.

## 🗂️ Repository Layout

```
.
├── api/                        # FastAPI demo application deployed to the cluster
│   ├── app/                    #   Application code (CRUD, models, schemas)
│   └── Dockerfile
├── iac/
│   ├── ansible/
│   │   └── roles/
│   │       ├── install-k8s/    #   Docker + Kubernetes packages
│   │       ├── create-cluster/ #   kubeadm init on the control plane
│   │       ├── join-workers/   #   Workers join the cluster
│   │       ├── install-helm/   #   Helm bootstrap
│   │       └── k8s-features/   #   Gateway API (Envoy Gateway) and add-ons
│   └── terraform/
│       ├── main.tf             # Root module (wraps ./modules)
│       ├── modules/            # VPC, subnets, SG, EC2, ALB, key pair
│       ├── docker-compose.localstack.yml
│       └── localstack.tfvars.example
├── k8s/
│   ├── helmcharts/             # simpleapi and db charts
│   ├── gateway/                # Shared Gateway API manifest (Gateway + HTTPRoute)
│   └── manifests/              # Raw manifests (api, db, misc)
└── .github/workflows/          # CI (LocalStack plan), deploy, destroy
```

## 🛠️ Tooling (mise)

All CLIs are pinned with [mise](https://mise.jdx.dev) — no "works on my machine":

| Tool | Purpose |
|------|---------|
| `terraform` | Infrastructure provisioning |
| `terraform-docs` | Auto-generate module documentation |
| `tflint` | Lint and best-practice checks |

```bash
curl https://mise.run | sh   # one-time install
cd k8s-iac                   # mise installs everything from mise.toml automatically
```

## 🏗️ Terraform

The root module wraps `iac/terraform/modules`, which provisions:

- **Networking** — VPC with DNS support, two public subnets across two AZs, internet gateway, route tables
- **Security** — security group covering SSH, HTTP/HTTPS, kube-apiserver (6443), NodePort range and intra-cluster traffic
- **Compute** — 1 control plane + 2 worker nodes (Ubuntu 22.04 LTS, AMI resolved dynamically via data source)
- **Load balancing** — Application Load Balancer with health checks targeting the nodes
- **Convenience** — instance IPs written to `iac/address/` for Ansible consumption

<details>
<summary><b>📋 Module inputs</b></summary>

| Variable | Description | Default |
|----------|-------------|---------|
| `project_name` | Resource naming/tagging prefix | `k8s-iac` |
| `aws_region` | AWS region | `us-east-1` |
| `ami_id` | AMI override (empty = latest Ubuntu 22.04) | `""` |
| `instance_type_master` | Control plane instance type | `t3.large` |
| `instance_type_node` | Worker instance type | `t3.large` |
| `instance_count_master` | Control plane node count | `1` |
| `instance_count_node` | Worker node count | `2` |
| `public_key` | SSH public key material (required) | — |
| `vpc_cidr_block` | VPC CIDR | `10.0.0.0/16` |
| `public_cidr_block1/2` | Public subnet CIDRs | `10.0.1.0/24`, `10.0.2.0/24` |
| `availability_zone1/2` | Subnet AZs | `us-east-1a`, `us-east-1b` |
| `ssh_ingress_cidrs` | CIDRs allowed to SSH — restrict in production! | `["0.0.0.0/0"]` |

</details>

### 🚀 Deploy to real AWS

Credentials come from the environment (locally) or repository secrets (CI: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `SSH_PUBLIC_KEY`).

```bash
cd iac/terraform
terraform init
terraform plan  -var="public_key=$(cat ~/.ssh/id_rsa.pub)"
terraform apply -auto-approve -var="public_key=$(cat ~/.ssh/id_rsa.pub)"
```

Remote state lives in S3 (bucket `terraform-state-duran`). Adjust the `backend "s3"` block in `main.tf` for your own bucket.

### 🧪 Test locally with LocalStack

[LocalStack](https://localstack.cloud) emulates AWS APIs, so the full configuration is validated without touching (or paying for) real infrastructure:

```bash
cd iac/terraform

# 1. Start the emulator (community edition — no license needed)
docker compose -f docker-compose.localstack.yml up -d --wait

# 2. Point the AWS provider at it
source localstack.env

# 3. Init without the S3 backend and plan
terraform init -backend=false
terraform plan -var-file=localstack.tfvars.example -var="public_key=$(cat ~/.ssh/id_rsa.pub)"
```

> **Note:** `localstack.tfvars.example` pins a dummy AMI because LocalStack has no AMI catalog. The `localstack.env` file is git-ignored — recreate it with `AWS_ACCESS_KEY_ID=test`, `AWS_SECRET_ACCESS_KEY=test` and `AWS_ENDPOINT_URL=http://localhost:4566`.

## 🤖 GitHub Actions

| Workflow | Trigger | What it does |
|----------|---------|--------------|
| [`terraform-ci.yml`](.github/workflows/terraform-ci.yml) | PR / push touching `iac/terraform/**` | `fmt -check`, `validate`, `tflint` + full `terraform plan` against LocalStack |
| [`deploy.workflow.yaml`](.github/workflows/deploy.workflow.yaml) | Manual (`workflow_dispatch`) | init → validate → plan → apply against real AWS |
| [`destroy.workflow.yaml`](.github/workflows/destroy.workflow.yaml) | Manual (`workflow_dispatch`) | Teardown of the provisioned infrastructure |

The CI badge at the top reflects the latest LocalStack validation run.

## ⚙️ Ansible

Roles run from `iac/ansible` against the IPs Terraform writes to `iac/address/`:

1. **install-k8s** — Docker engine + kubeadm/kubelet/kubectl
2. **create-cluster** — `kubeadm init` + CNI on the control plane
3. **join-workers** — workers join using the bootstrap token
4. **install-helm** — Helm binary and tiller-less setup
5. **k8s-features** — Envoy Gateway (Gateway API), metrics-server, kube-prometheus-stack

## 🗺️ Roadmap

- [ ] Terraform tests with [Terratest](https://terratest.gruntwork.io) or `terraform test`
- [ ] Migrate kubeadm bootstrap to a managed option (EKS) as an alternative path
- [ ] Renovate/Dependabot for GitHub Actions and provider version bumps
- [ ] Per-module `terraform-docs` generated docs in CI

## 📄 License

MIT — see [LICENSE](LICENSE).
