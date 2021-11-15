# Help
help:
	cat doc/make.help

# Variables
SINGLE := network cluster/master cluster/slaves cluster/bastion  	 # order apply
TEMP_SINGLE := single/network single/cluster/master single/cluster/slaves single/cluster/bastion  	 # single bug solution
REV_SINGLE := cluster/slaves cluster/master cluster/bastion network 	 # order destroy


# Internal variables
#act=plan	# Action to do with component
#BUILD_DEBUG=yes	# Allow to redefine variables



# Single action for infra
$(TEMP_SINGLE): _check_act
	# Correct PATH
	$(eval  TMP_PATH=$(shell echo $@ | cut -d '/' -f 2- ))
	yes yes | terraform -chdir=gcp/$(TMP_PATH) $(act)


# Main targets: apply, destroy
cluster/on: _set-up _apply-instances
cluster/off: _set-down _apply-instances

cluster/init:	
	# Init cluster
	for i in  $(SINGLE); do \
		terraform -chdir=gcp/$$i init ; \
	done
	@echo "[init cluster] OK"


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
_upload_files: get/hosts
	# rsync better than scp
	$(eval  EXTERNAL_IP=$(shell terraform -chdir=gcp/cluster/bastion output -json bastion-public-ip | sed 's/"//g'))
	# -o StrictHostKeyChecking=no 		- turn off fingerprint checking prompt
	# -o UserKnownHostsFile=/dev/null 	- fix `WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!`
	# -o LogLevel=quite 			- turn off Warnings
	rsync -Pav -e "ssh -i cred/id_rsa -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"  cred/id_rsa* debian@$(EXTERNAL_IP):/home/debian/.ssh
	rsync -Pav -e "ssh -i cred/id_rsa -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"  kube-gcp/*   debian@$(EXTERNAL_IP):/home/debian/
	@echo "[set/upload_files] OK"


# Other targets:
# Ansible hosts setup
get/hosts:
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
	# set into backends:
	for i in $(SINGLE); do \
		echo ""; \
		echo "gcp/$$i/backend.tf:" ;\
		sed -r 's/ bucket.*/ bucket\t= \"'"$(VALUE)"'\"/g' -i  gcp/$$i/backend.tf  ;\
		grep "bucket" gcp/$$i/backend.tf ;\
	done
	# set into varriable.tf
	echo "gcp/variable.tf:" 
	sed -r 's/"bucket" \{.*/"bucket" \{ default = \"'"$(VALUE)"'\" \}/g'  -i  gcp/variable.tf
	grep "bucket" gcp/variable.tf 
	@echo [set/bucket] OK
set/project_id: _check_VALUE
	# set into variable.tf:
	sed -r 's/"project_id" \{.*/"project_id" \{ default = \"'"$(VALUE)"'\" \}/g' -i  gcp/variable.tf
	grep "project_id" gcp/variable.tf
	#
	# set into kube-gcp/files/cloud-config
	sed -r 's/project-id =.*/project-id = '"$(VALUE)"'/g' -i kube-gcp/files/cloud-config
	grep "project-id"  kube-gcp/files/cloud-config
	@echo [set/project_id] OK

############################ Need Optimization ###########################
# Get ssh link:
# have bugs!!! maybe you need to run it a few times
get/bastion-ssh:
	terraform -chdir=gcp/cluster/bastion apply -auto-approve
	$(eval  EXTERNAL_IP=$(shell terraform -chdir=gcp/cluster/bastion output -json bastion-public-ip | sed 's/"//g'))
	@echo "ssh -i cred/id_rsa debian@$(EXTERNAL_IP)"

# Experimantal feature !!! Be careful!!!
install/k8s: _upload_files
	# 1. GET EXTERNAL_IP
	$(eval  EXTERNAL_IP=$(shell terraform -chdir=gcp/cluster/bastion output -json bastion-public-ip | sed 's/"//g'))
	# 1.1 Check EXTERNAL_IP
	@echo "$(EXTERNAL_IP):/home/debian/"
	# 2. Install k8s
	# 2.1 install pip3
	ssh -i cred/id_rsa  debian@$(EXTERNAL_IP)  ./ansible_install.sh
	@echo "[pip3 installed] OK"
	# 2.2 ansible ping
	ssh -i cred/id_rsa  debian@$(EXTERNAL_IP)  ansible -m ping all
	@echo "[ansible ping] OK"
	# 2.3 install k8s
	@echo "[install K8S] Starting ..."
	ssh -i cred/id_rsa  debian@$(EXTERNAL_IP)  ansible-playbook install-cluster.yml | tee ansible.log
	@echo "[install K8S] OK"


# Get .kube/config
get/kubeconfig:
	$(eval  EXTERNAL_IP=$(shell terraform -chdir=gcp/cluster/bastion output -json bastion-public-ip | sed 's/"//g'))
	# Copy from master to bastion
	ssh -i cred/id_rsa debian@$(EXTERNAL_IP) ansible-playbook addons/get_kubeconfig.yaml
	$(eval  MASTER1_IP=$(shell  terraform -chdir=gcp/cluster/master  output -json master1-private-ip | sed s/\,/\\n/g | sed 's/\[//g' | sed 's/\]//g' | sed  's/"//g'))
	# Copy config from bastion
	rsync -Pav -e "ssh -i cred/id_rsa -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" debian@$(EXTERNAL_IP):/tmp/$(MASTER1_IP)/etc/kubernetes/admin.conf /tmp/
	# Change ip on dns # You need to have "127.0.0.1 master-1" in your /etc/hosts !!!!
	sed -i 's/$(MASTER1_IP)/master-1/' /tmp/admin.conf
	cp /tmp/admin.config ~/.kube/config

get/ssh-tunnel:
	# Get Variables
	$(eval  MASTER1_IP=$(shell  terraform -chdir=gcp/cluster/master  output -json master1-private-ip | sed s/\,/\\n/g | sed 's/\[//g' | sed 's/\]//g' | sed  's/"//g'))
	$(eval  EXTERNAL_IP=$(shell terraform -chdir=gcp/cluster/bastion output -json bastion-public-ip | sed 's/"//g'))
	if lsof -Pi :6443 -sTCP:LISTEN -t >/dev/null ; then \
	    echo "running 6443"; \
	else \
	    ssh -i cred/id_rsa -fNL 6443:$(MASTER1_IP):6443 debian@$(EXTERNAL_IP) ; \
	fi	
	@echo [get/ssh-tunnel] OK
