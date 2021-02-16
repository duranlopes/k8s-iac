<h1 align="">K8s-IaC ✔️ </h1>
<p>
  <a href="/" target="_blank">
    <img alt="Documentation" src="https://img.shields.io/badge/documentation-yes-brightgreen.svg" />
  </a>
  <a href="/LICENSE" target="_blank">
    <img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-yellow.svg" />
  </a>
  </a>
</p>


> A ideia principal desse repo é prover um cluster Kubernetes utilizando as principais ferramentas de IaC utilizadas no momento, para fins de estudos e testes de novas tecnologias relacionadas ao Kubernetes.


## Github Actions

- build terraform artifacts
- terraform backend in aws s3
- terraform init, validate, plan and show external and master internal

## Terraform 

- vpc
- subnet
- security group
- key pair 
- ec2 (master , nodes)
- return external IPs `/iac/address`

```
cd iac/terraform
terraform apply -auto-approve
```

## Ansible roles

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


### Install Helm

- Install helm
- Init helm

```
cd iac/ansible
ansible-playbook -i hosts main.yml
```

## Deploy Helm Charts tests


- api:

```
    helm install simpleapi k8s/helmcharts/simpleapi/
```

- db:

```
    helm install db k8s/helmcharts/db/
```