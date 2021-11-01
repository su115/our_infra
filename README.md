# our_infra
## Install 
### Requirements
### Public and private keys to access to bastion, masters and slaves  _gcp_main gcp_main.pub_. 
### GCP service account with key _credterraform.json_ that allow you access to GCP.(Rename your _key.json_ to _credterraform.json_ or change __backend.tf__)
### terraform

### 1. Clone 
```sh
git clone https://github.com/su115/our_infra.git
cd our_infra
```
### 2. Copy _gcp_main gcp_main.pub_ and _credterraform.json__
### 3. Change bucket name to your CUSTOM!!!
### 4. Terraform init and apply
```sh
terraform init
terraform apply
```
# CRAZY__TESTING
