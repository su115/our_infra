
default:
	@echo "cat help here."

up: set-up apply
down: set-down apply
# Variables
SINGLE := network cluster/master cluster/slaves cluster/bastion
MAIN := apply destroy output plan
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

set-up:
	sed -i gcp/variable.tf  -e  's/variable "status-slaves" { default = "TERMINATED" }/variable "status-slaves" { default = "RUNNING" }/g'
	sed -i gcp/variable.tf  -e  's/variable "status-master" { default = "TERMINATED" }/variable "status-master" { default = "RUNNING" }/g'
	sed -i gcp/variable.tf  -e  's/variable "status-bastion" { default = "TERMINATED" }/variable "status-bastion" { default = "RUNNING" }/g'
set-down:
	sed -i gcp/variable.tf  -e  's/variable "status-slaves" { default = "RUNNING" }/variable "status-slaves" { default = "TERMINATED" }/g'
	sed -i gcp/variable.tf  -e  's/variable "status-master" { default = "RUNNING" }/variable "status-master" { default = "TERMINATED" }/g'
	sed -i gcp/variable.tf  -e  's/variable "status-bastion" { default = "RUNNING" }/variable "status-bastion" { default = "TERMINATED" }/g'

