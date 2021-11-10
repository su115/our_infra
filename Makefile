# Help
help:
	@echo "cat help here."

# Variables
SINGLE := gcp/network gcp/cluster/master gcp/cluster/slaves gcp/cluster/bastion  	 # For apply
REV_SINGLE := gcp/cluster/slaves gcp/cluster/master gcp/cluster/bastion gcp/network 	 # For destroy


# Internal variables
act=plan	# Action to do with component
BUILD_DEBUG=yes	# Allow to redefine variables



# Single action for infra
$(SINGLE):
	yes yes | terraform -chdir=$@ $(act)


# Main targets: apply, destroy
cluster/on: _set-up _apply-instances
cluster/off: _set-down _apply-instances


cluster/apply:
	# Apply cluster
	for i in  $(SINGLE); do \
		terraform -chdir=$$i apply -auto-approve ; \
	done
	@echo "[Apply cluster] OK"

cluster/destroy:
	# Destroy cluster	
	for i in  $(REV_SINGLE); do \
		terraform -chdir=$$i destroy -auto-approve ; \
	done
	@echo "[Destroy cluster] OK"

# Internal targets: for (on/off)
_apply-instances:
	for i in  gcp/cluster/* ; do \
		terraform -chdir=$$i apply -auto-approve ; \
	done

_set-up:
	sed -i gcp/variable.tf  -e  's/variable "status-slaves" { default = "TERMINATED" }/variable "status-slaves" { default = "RUNNING" }/g'
	sed -i gcp/variable.tf  -e  's/variable "status-master" { default = "TERMINATED" }/variable "status-master" { default = "RUNNING" }/g'
	sed -i gcp/variable.tf  -e  's/variable "status-bastion" { default = "TERMINATED" }/variable "status-bastion" { default = "RUNNING" }/g'

_set-down:
	sed -i gcp/variable.tf  -e  's/variable "status-slaves" { default = "RUNNING" }/variable "status-slaves" { default = "TERMINATED" }/g'
	sed -i gcp/variable.tf  -e  's/variable "status-master" { default = "RUNNING" }/variable "status-master" { default = "TERMINATED" }/g'
	sed -i gcp/variable.tf  -e  's/variable "status-bastion" { default = "RUNNING" }/variable "status-bastion" { default = "TERMINATED" }/g'

# Other targets:
# Ansible hosts setup
set/hosts:
	# Add master ip
	echo "[masters]" > kube-gcp/hosts
	terraform -chdir=gcp/cluster/master output -json master-private-ips | sed s/\,/\\n/g | sed 's/\[//g' | sed 's/\]//g' | sed  's/"//g' >> kube-gcp/hosts
	@echo [masters] OK
	# Add slaves
	echo "[slaves]" >> kube-gcp/hosts
	terraform -chdir=gcp/cluster/slaves output -json slaves-private-ips | sed s/\,/\\n/g | sed 's/\[//g' | sed 's/\]//g' | sed  's/"//g' >> kube-gcp/hosts
	@echo [slaves] OK
	@echo [set/hosts] OK

############################ Need Optimization ###########################
# Get ssh link:
# have bugs!!! maybe you need to run it a few times
get/bastion-ssh:
	terraform -chdir=gcp/cluster/bastion apply -auto-approve
	$(eval  EXTERNAL_IP=$(shell terraform -chdir=gcp/cluster/bastion output -json bastion-public-ip | sed 's/"//g'))
	@echo "ssh -i cred/id_rsa debian@$(EXTERNAL_IP)"

# Experimantal feature !!! Be careful!!!
install/k8s:%:set/hosts
	# 1. GET EXTERNAL_IP
	$(eval  EXTERNAL_IP=$(shell terraform -chdir=gcp/cluster/bastion output -json bastion-public-ip | sed 's/"//g'))
	# 1.1 Check EXTERNAL_IP
	@echo "$(EXTERNAL_IP):/home/debian/"
	# 2. Download files
	# rsync better than scp
	rsync -Pav -e "ssh -i cred/id_rsa"  cred/id_rsa* debian@$(EXTERNAL_IP):/home/debian/.ssh
	rsync -Pav -e "ssh -i cred/id_rsa -o StrictHostKeyChecking=no"  kube-gcp/*   debian@$(EXTERNAL_IP):/home/debian/
	# 3. Install k8s
	# 3.1 install pip3 
	ssh -i cred/id_rsa  debian@$(EXTERNAL_IP)  ./ansible_install.sh
	@echo "[pip3 installed] OK"
	# 3.2 ansible ping
	ssh -i cred/id_rsa  debian@$(EXTERNAL_IP)  ansible -m ping all > ansible.log
	@echo "[ansible ping] OK"
	# 3.3 install k8s
	@echo "[install K8S] Starting ..."
	ssh -i cred/id_rsa  debian@$(EXTERNAL_IP)  ansible-playbook install-cluster.yml >> ansible.log
	@echo "[install K8S] OK"



