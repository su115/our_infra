# Help
help:
	cat doc/make.help

# Variables
SINGLE := network cluster/master cluster/slaves cluster/bastion  	 # For apply
REV_SINGLE := cluster/slaves cluster/master cluster/bastion network 	 # For destroy


# Internal variables
act=plan	# Action to do with component
BUILD_DEBUG=yes	# Allow to redefine variables



# Single action for infra
single/$(SINGLE): _check_act
	# Correct PATH
	$(eval  TMP_PATH=$(shell echo $@ | cut -d '/' -f 2- ))
	yes yes | terraform -chdir=gcp/$(TMP_PATH) $(act)


# Main targets: apply, destroy
cluster/on: _set-up _apply-instances
cluster/off: _set-down _apply-instances


cluster/apply:
	# Apply cluster
	for i in  $(SINGLE); do \
		terraform -chdir=gcp/$$i apply -auto-approve ; \
	done
	@echo "[Apply cluster] OK"

cluster/destroy:
	# Destroy cluster
	for i in  $(REV_SINGLE); do \
		terraform -chdir=gcp/$$i destroy -auto-approve ; \
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
# Upload files on bastion
set/upload_files: set/hosts
	# rsync better than scp
	$(eval  EXTERNAL_IP=$(shell terraform -chdir=gcp/cluster/bastion output -json bastion-public-ip | sed 's/"//g'))
	# -o StrictHostKeyChecking=no 		- turn off fingerprint checking prompt
	# -o UserKnownHostsFile=/dev/null 	- fix `WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!`
	# -o LogLevel=quite 			- turn off Warnings
	rsync -Pav -e "ssh -i cred/id_rsa -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quite"  cred/id_rsa* debian@$(EXTERNAL_IP):/home/debian/.ssh
	rsync -Pav -e "ssh -i cred/id_rsa -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quite"  kube-gcp/*   debian@$(EXTERNAL_IP):/home/debian/
	@echo "[set/upload_files] OK"


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
_check_act:
ifndef act
	$(error "`atc` is undefined")
endif

_check_VALUE:
ifndef VALUE
	# Check is `VALUE` defined
	$(error "VALUE is undefined")
endif

set/sa-email: _check_VALUE
	# change email 
	sed  -r 's/"email" \{.*/"email" \{ default \= \"'"$(VALUE)"'\" \}/g' -i  gcp/variable.tf
	grep "email" gcp/variable.tf
	@echo $(VALUE)

set/bucket: _check_VALUE
	# set bucket in backends:
	for i in $(SINGLE); do \
		echo ""; \
		echo "gcp/$$i/backend.tf:" ;\
		sed -r 's/ bucket.*/ bucket\t= \"'"$(VALUE)"'\"/g' -i  gcp/$$i/backend.tf  ;\
		grep "bucket" gcp/$$i/backend.tf ;\
	done
	@echo [set/bucket] OK
#set/projectl-id:

############################ Need Optimization ###########################
# Get ssh link:
# have bugs!!! maybe you need to run it a few times
get/bastion-ssh:
	terraform -chdir=gcp/cluster/bastion apply -auto-approve
	$(eval  EXTERNAL_IP=$(shell terraform -chdir=gcp/cluster/bastion output -json bastion-public-ip | sed 's/"//g'))
	@echo "ssh -i cred/id_rsa debian@$(EXTERNAL_IP)"

# Experimantal feature !!! Be careful!!!
install/k8s: set/upload_files
	# 1. GET EXTERNAL_IP
	$(eval  EXTERNAL_IP=$(shell terraform -chdir=gcp/cluster/bastion output -json bastion-public-ip | sed 's/"//g'))
	# 1.1 Check EXTERNAL_IP
	@echo "$(EXTERNAL_IP):/home/debian/"
	# 3. Install k8s
	# 3.1 install pip3
	ssh -i cred/id_rsa  debian@$(EXTERNAL_IP)  ./ansible_install.sh
	@echo "[pip3 installed] OK"
	# 3.2 ansible ping
	ssh -i cred/id_rsa  debian@$(EXTERNAL_IP)  ansible -m ping all
	@echo "[ansible ping] OK"
	# 3.3 install k8s
	@echo "[install K8S] Starting ..."
	ssh -i cred/id_rsa  debian@$(EXTERNAL_IP)  ansible-playbook install-cluster.yml | tee ansible.log
	@echo "[install K8S] OK"



