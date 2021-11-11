# our_infra
# CRAZY__TESTING
## Setup 
### Put to _cred/_ :
- ### Public and private keys to access to bastion, masters and slaves  _id_rsa id_rsa.pub_.
- ### GCP service account with key _credterraform.json_ that allow you access to GCP.(Rename your _key.json_ to _credterraform.json_ or change __backend.tf__)
### Manualy create bucket.
### Create service account. Give access.
### Install terraform
#
## Install
```sh
# 1. Clone repo
git clone https://github.com/su115/our_infra.git
cd our_infra

# 1.1 Install 
sudo apt-get install rsync -y


# 2. Setup to work
make set/project_id VALUE=<project-id>
make set/bucket     VALUE=<bucket>
make set/sa-email   VALUE=<service account email>

# 3. Init cluster
make cluster/init

# 4. Apply cluster
make cluster/apply

# 5. Install k8s 
make install/k8s

# 6. Get bastion url
make get/bastion-ssh
```
### login to master and have fun!!!
