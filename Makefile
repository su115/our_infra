
default:
	@echo "cat help here."
# Targets:
cluster-up: _set-up apply
cluster-down: _set-down apply

# Variables
SINGLE := network cluster/master cluster/slaves cluster/bastion
MAIN := apply output plan
act=plan
BUILD_DEBUG=yes	# Allow re define variables


# Check if `atc` is in `MAIN`
ifeq ($(filter $(act),$(MAIN)),)
    $(info $(act) does not exist in $(MAIN))
endif


# Single action for infra
$(SINGLE):
	yes yes | terraform -chdir=gcp/$@ $(act)


# Main targets: apply, destroy, plan 
$(MAIN):
	for i in  $(SINGLE); do \
		yes yes | terraform -chdir=gcp/$$i $@ ; \
		echo "$@ $$i" ; \
	done
############################ Need Optimization ###########################
destroy:
	yes yes | terraform -chdir=gcp/cluster/slaves destroy 
	yes yes | terraform -chdir=gcp/cluster/master destroy
	yes yes | terraform -chdir=gcp/cluster/bastion destroy
	yes yes | terraform -chdir=gcp/network destroy 

_set-up:
	sed -i gcp/variable.tf  -e  's/variable "status-slaves" { default = "TERMINATED" }/variable "status-slaves" { default = "RUNNING" }/g'
	sed -i gcp/variable.tf  -e  's/variable "status-master" { default = "TERMINATED" }/variable "status-master" { default = "RUNNING" }/g'
	sed -i gcp/variable.tf  -e  's/variable "status-bastion" { default = "TERMINATED" }/variable "status-bastion" { default = "RUNNING" }/g'

_set-down:
	sed -i gcp/variable.tf  -e  's/variable "status-slaves" { default = "RUNNING" }/variable "status-slaves" { default = "TERMINATED" }/g'
	sed -i gcp/variable.tf  -e  's/variable "status-master" { default = "RUNNING" }/variable "status-master" { default = "TERMINATED" }/g'
	sed -i gcp/variable.tf  -e  's/variable "status-bastion" { default = "RUNNING" }/variable "status-bastion" { default = "TERMINATED" }/g'


# set ips into hosts 
set-hosts:
	# Rewrite kube-gcp/hosts
	# Add master ip
	echo "[masters]" > kube-gcp/hosts
	terraform -chdir=gcp/cluster/master output -json master-private-ips | sed s/\,/\\n/g | sed 's/\[//g' | sed 's/\]//g' | sed  's/"//g' >> kube-gcp/hosts
	@echo [masters] OK
	# Add slaves
	echo "[slaves]" >> kube-gcp/hosts
	terraform -chdir=gcp/cluster/slaves output -json slaves-private-ips | sed s/\,/\\n/g | sed 's/\[//g' | sed 's/\]//g' | sed  's/"//g' >> kube-gcp/hosts
	@echo [slaves] OK
get-bastion-ssh:
	yes yes | terraform -chdir=gcp/cluster/bastion apply
	$(eval  EXTERNAL_IP=$(shell terraform -chdir=gcp/cluster/bastion output -json bastion-public-ip | sed 's/"//g'))
	@echo "ssh -i cred/id_rsa debian@$(EXTERNAL_IP)"

# Experimantal feature !!! Be careful!!!
install-k8s:%:set-hosts
	$(eval  EXTERNAL_IP=$(shell terraform -chdir=gcp/cluster/bastion output -json bastion-public-ip | sed 's/"//g'))
	@echo "$(EXTERNAL_IP):/home/debian/"
	rsync -Pav -e "ssh -i cred/id_rsa"  cred/id_rsa* debian@$(EXTERNAL_IP):/home/debian/.ssh
	#rsyn beter scp
	rsync -Pav -e "ssh -i cred/id_rsa -o StrictHostKeyChecking=no"  kube-gcp/*   debian@$(EXTERNAL_IP):/home/debian/  
	ssh -i cred/id_rsa  debian@$(EXTERNAL_IP)  ./ansible_install.sh
	#PING
	ssh -i cred/id_rsa  debian@$(EXTERNAL_IP)  ansible -m ping all > ansible.log
	ssh -i cred/id_rsa  debian@$(EXTERNAL_IP)  ansible-playbook install-cluster.yml >> ansible.log



