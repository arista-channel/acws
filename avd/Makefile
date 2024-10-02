.PHONY: help
help: ## Display help message
	@grep -E '^[0-9a-zA-Z_-]+\.*[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

########################################################
# FABRICS
########################################################

# FABRIC A
########################################################

.PHONY: ping-a
ping-a: ## Ping Nodes
	ansible-playbook playbooks/ping.yml -i sites/fabric-a/inventory.yml

.PHONY: build
build: ## Build Configs
	ansible-playbook playbooks/pb.build.yml -i sites/atd_lab/inventory.yml --tags build,generate -e "target_hosts=ATD_LAB" -e "fabric=atd_lab"

.PHONY: build-act
build-act-a: ## Build Configs
	ansible-playbook playbooks/pb.build.yml -i sites/fabric-a/inventory.yml --tags act,build,generate -e "target_hosts=FABRICS" -e "fabric=fabric-a"

.PHONY: deploy
deploy-a: ## Deploy using CV CI workflow (i.e. workspaces, studios, etc)
	ansible-playbook playbooks/pb.deploy.yml -i sites/fabric-a/inventory.yml -e "target_hosts=FABRICS"

.PHONY: validate
validate-a:
	ansible-playbook playbooks/pb.validate.yml -i sites/fabric-a/inventory.yml -e "target_hosts=FABRICS"

.PHONY: build-topo
build-topo-a:
	ansible-playbook playbooks/pb.gen-act-topo.yml -i sites/fabric-a/inventory.yml
