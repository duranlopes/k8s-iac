# =============================================================================
# k8s-iac — Infrastructure, Kubernetes and Application tasks
# =============================================================================
# Usage:   make <target>        (run `make help` for the full list)
# All tools are provided by mise (terraform, tflint, terraform-docs, kubectl,
# helm, ansible-lint). Run `mise install` first if any tool is missing.
# =============================================================================

# --- Configuration -----------------------------------------------------------
TERRAFORM_DIR  := iac/terraform
ANSIBLE_DIR    := iac/ansible
HELM_DIR       := k8s/helmcharts
GATEWAY_MANIFEST := k8s/gateway/gateway.yaml

TFVARS_FILE    ?= localstack.tfvars.example
ANSIBLE_INVENTORY ?= inventory.ini

SHELL          := /bin/bash
.DEFAULT_GOAL  := help
.PHONY: help $(MAKECMDGOALS)

# --- Helpers -----------------------------------------------------------------
define BANNER
	@printf '\n\033[1;36m==> %s\033[0m\n' "$(1)"
endef

## help: Show this help
help:
	@printf 'Usage: make \033[1m<target>\033[0m\n\n'
	@printf '\033[1m%s\033[0m\n' 'Terraform'
	@grep -E '^## tf|^## localstack' $(MAKEFILE_LIST) | sed -e 's/^## //' -e 's/:/ — /' | awk '{printf "  %-20s%s\n", $$1, substr($$0, index($$0,$$2))}'
	@printf '\n\033[1m%s\033[0m\n' 'Ansible'
	@grep -E '^## ansible' $(MAKEFILE_LIST) | sed -e 's/^## //' -e 's/:/ — /' | awk '{printf "  %-20s%s\n", $$1, substr($$0, index($$0,$$2))}'
	@printf '\n\033[1m%s\033[0m\n' 'Helm'
	@grep -E '^## helm' $(MAKEFILE_LIST) | sed -e 's/^## //' -e 's/:/ — /' | awk '{printf "  %-20s%s\n", $$1, substr($$0, index($$0,$$2))}'
	@printf '\n\033[1m%s\033[0m\n' 'Kubernetes / Gateway API'
	@grep -E '^## k8s' $(MAKEFILE_LIST) | sed -e 's/^## //' -e 's/:/ — /' | awk '{printf "  %-20s%s\n", $$1, substr($$0, index($$0,$$2))}'
	@printf '\n\033[1m%s\033[0m\n' 'Quality gates'
	@grep -E '^## lint:|^## validate:|^## ci:' $(MAKEFILE_LIST) | sed -e 's/^## //' -e 's/:/ — /' | awk '{printf "  %-20s%s\n", $$1, substr($$0, index($$0,$$2))}'
	@echo

# =============================================================================
# Terraform (LocalStack-ready)
# =============================================================================

## tf-init: Initialize the Terraform working directory
tf-init:
	$(call BANNER,$@)
	cd $(TERRAFORM_DIR) && terraform init -reconfigure

## tf-fmt: Check formatting without rewriting files
tf-fmt:
	$(call BANNER,$@)
	cd $(TERRAFORM_DIR) && terraform fmt -check -recursive

## tf-fmt-fix: Rewrite Terraform files to canonical format
tf-fmt-fix:
	$(call BANNER,$@)
	cd $(TERRAFORM_DIR) && terraform fmt -recursive

## tf-validate: Validate configuration and modules
tf-validate: tf-init
	$(call BANNER,$@)
	cd $(TERRAFORM_DIR) && terraform validate

## tf-lint: Run TFLint with all plugins
tf-lint:
	$(call BANNER,$@)
	cd $(TERRAFORM_DIR) && tflint --init && tflint --recursive

## tf-docs: Regenerate module documentation
tf-docs:
	$(call BANNER,$@)
	cd $(TERRAFORM_DIR) && terraform-docs .

## tf-plan: Plan against LocalStack using the example tfvars
tf-plan:
	$(call BANNER,$@)
	cd $(TERRAFORM_DIR) && terraform plan -var-file=$(TFVARS_FILE)

## tf-apply: Apply against LocalStack using the example tfvars
tf-apply:
	$(call BANNER,$@)
	cd $(TERRAFORM_DIR) && terraform apply -var-file=$(TFVARS_FILE)

## tf-destroy: Destroy LocalStack-managed resources
tf-destroy:
	$(call BANNER,$@)
	cd $(TERRAFORM_DIR) && terraform destroy -var-file=$(TFVARS_FILE)

## localstack-up: Start the LocalStack container
localstack-up:
	$(call BANNER,$@)
	docker compose -f $(TERRAFORM_DIR)/docker-compose.localstack.yml up -d

## localstack-down: Stop the LocalStack container
localstack-down:
	$(call BANNER,$@)
	docker compose -f $(TERRAFORM_DIR)/docker-compose.localstack.yml down -v

# =============================================================================
# Ansible (cluster bootstrap + add-ons)
# =============================================================================

## ansible-install: Create venv and install collections/deps
ansible-install:
	$(call BANNER,$@)
	python3 -m venv $(ANSIBLE_DIR)/.venv
	$(ANSIBLE_DIR)/.venv/bin/pip install ansible ansible-lint kubernetes
	$(ANSIBLE_DIR)/.venv/bin/ansible-galaxy collection install -r $(ANSIBLE_DIR)/requirements.yml

## ansible-syntax: Syntax-check all playbooks
ansible-syntax:
	$(call BANNER,$@)
	cd $(ANSIBLE_DIR) && ansible-playbook -i $(ANSIBLE_INVENTORY) main.yml --syntax-check

## ansible-lint: Run ansible-lint (production profile)
ansible-lint:
	$(call BANNER,$@)
	cd $(ANSIBLE_DIR) && ansible-lint

## ansible-run: Apply the full bootstrap playbook
ansible-run:
	$(call BANNER,$@)
	cd $(ANSIBLE_DIR) && ansible-playbook -i $(ANSIBLE_INVENTORY) main.yml

# =============================================================================
# Helm charts
# =============================================================================

## helm-lint: Lint every chart under k8s/helmcharts
helm-lint:
	$(call BANNER,$@)
	@set -e; for chart in $(HELM_DIR)/*/; do helm lint $$chart; done

## helm-template: Render every chart (no cluster required)
helm-template:
	$(call BANNER,$@)
	@set -e; for chart in $(HELM_DIR)/*/; do echo "--- $$chart"; helm template $$(basename $$chart) $$chart > /dev/null; done

## helm-upgrade: Deploy simpleapi and db to the current context
helm-upgrade:
	$(call BANNER,$@)
	helm upgrade --install db $(HELM_DIR)/db --wait
	helm upgrade --install simpleapi $(HELM_DIR)/simpleapi --wait

## helm-uninstall: Remove both releases from the cluster
helm-uninstall:
	$(call BANNER,$@)
	helm uninstall simpleapi || true
	helm uninstall db || true

# =============================================================================
# Kubernetes / Gateway API
# =============================================================================

## k8s-gateway: Apply the shared Gateway API manifest
k8s-gateway:
	$(call BANNER,$@)
	kubectl apply -f $(GATEWAY_MANIFEST)

## k8s-status: Overview of pods, services and routes
k8s-status:
	$(call BANNER,$@)
	kubectl get pods,services,httproutes,gateways -o wide

# =============================================================================
# CI / quality gates
# =============================================================================

## lint: Run every linter (terraform fmt, tflint, ansible-lint, helm lint)
lint: tf-fmt tf-lint ansible-lint helm-lint
	$(call BANNER,$@ done — all linters passed)

## validate: Full validation (fmt + validate + lint + render)
validate: tf-fmt tf-validate tf-lint ansible-syntax ansible-lint helm-lint helm-template
	$(call BANNER,$@ done — all checks passed)

## ci: Same gate used by GitHub Actions before a push
ci: lint
