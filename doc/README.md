# Lets start
```sh
git clone https://github.com/su115/our_infra.git

### Set project main branch (for new users) or
### Setup project crazy-test branch (for advanced users)
git checkout crazy-test

cd our_infra

#### Create cred/
mkdir cred/
cd cred/
```
#### Add here id_rsa id_rsa.pub manualy
#### or create new keys 
```sh
# don`t forgot about permisions!!!!
ssh-keygen ssh-keygen -f id_rsa -t rsa -N ''
chmod 400 id_rsa
chmod 400 id_rsa.pub
```
# [gcloud SDK install](https://cloud.google.com/sdk/docs/install)
#### Be carefull!!!
```sh
{
sudo apt-get install apt-transport-https ca-certificates gnupg -y

echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

sudo apt-get update && sudo apt-get install google-cloud-sdk -y
}
```
# Init your gcloud
### This step you must do manualy by yourself !!!
```sh
gcloud init
```
# Setup gcloud
### Manualy too! 
```sh
# 1. Set project
gcloud projects list
export PROJECT_ID=test1508
gcloud config set project $PROJECT_ID

# 2. Enable Compute
gcloud services list --available
gcloud services enable compute.googleapis.com

# 3. Create SA (service account) for terraform, roles/owner !!!!
export SA_NAME="sa-terraform"
gcloud iam service-accounts create $SA_NAME
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/owner"

# 4. Get credterraform.json
gcloud iam service-accounts keys create credterraform.json --iam-account=$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com

# 5. Create bucket
export BUCKET=terraform-bucket-1712
gsutil mb gs://$BUCKET/
```
# [Install terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
```sh
{
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform -y
}
```

# INIT CLUSTER
## ONLY FOR CRAZY-TEST BRANCH
### Install packages
```sh
sudo apt install make rsync -y

# Set Variables
make set/project_id VALUE=$PROJECT_ID
make set/bucket     VALUE=$BUCKET
make set/sa-email   VALUE=$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com

# Save changed variables
# Don`t push your changes!!!
git add .
git commit -m "Save setup"
# cred/ is ignored by .gitignore

# init terraform backend only once.
make cluster/init

# apply infrastructure
make cluster/apply
# You maybe got error
#  Error: storage.NewClient() failed: dialing: google: could not find default credentials. See https://developers.google.com/accounts/docs/application-default-credentials for more information.
# Solution is manualy:
gcloud auth application-default login

# Install K8S
make install/k8s

# Get ssh
make get/bastion-ssh
```

