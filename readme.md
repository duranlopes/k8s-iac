# Iac for creating a Kubernetes cluster using Aws Ec2


Terraform 
---

### Main module

- vpc
- security group
- key_pair
- ec2 instances (master, node)

Ansible
---

### Install k8s


- Install docker
- Install kubernetes

### Create cluster

- Reset cluster (if exists)
- Update k8s images
- Initiate a cluster with 'kubeadm'
- Install Weavenet CNI


### Nodes Join Workers

- Reset previous config
- Join cluster