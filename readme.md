IaC - Kubernetes
=========

## This IaC provides a cluster at Aws using EC2 instances. I used Terraform to provision Aws EC2 Instances and Ansible to configure linux servers and integrate the master with the nodes.

## Terraform 

- vpc
- subnet
- security group
- key pair 
- ec2 (master , nodes)
- return external IPs `/iac/address`


## Ansible

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

### Helm

- Install helm
- Init helm
