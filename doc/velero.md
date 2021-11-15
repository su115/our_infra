# Velero
![structure](https://res.cloudinary.com/practicaldev/image/fetch/s--GcPWwwvX--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://velero.io/docs/v1.5/img/backup-process.png)
# Setup bucket and service account
## Make sure that `kubectl`+`ssh tunnel` works.
### Next steps is described [here.](https://github.com/vmware-tanzu/velero-plugin-for-gcp)
```sh
# 1. Create bucket
BUCKET=velero-bucket-1315  #<YOUR_BUCKET> uniq name
gsutil mb gs://$BUCKET/

# Check config
gcloud config list
PROJECT_ID=$(gcloud config get-value project)

# 2. Create service-account
gcloud iam service-accounts create velero \
    --display-name "Velero service account"
gcloud iam service-accounts list
# Get email
SERVICE_ACCOUNT_EMAIL=$(gcloud iam service-accounts list \
  --filter="displayName:Velero service account" \
  --format 'value(email)')

# 3. Attach policies and give permissions
ROLE_PERMISSIONS=(
    compute.disks.get
    compute.disks.create
    compute.disks.createSnapshot
    compute.snapshots.get
    compute.snapshots.create
    compute.snapshots.useReadOnly
    compute.snapshots.delete
    compute.zones.get
)

gcloud iam roles create velero.server \
    --project $PROJECT_ID \
    --title "Velero Server" \
    --permissions "$(IFS=","; echo "${ROLE_PERMISSIONS[*]}")"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member serviceAccount:$SERVICE_ACCOUNT_EMAIL \
    --role projects/$PROJECT_ID/roles/velero.server

gsutil iam ch serviceAccount:$SERVICE_ACCOUNT_EMAIL:objectAdmin gs://${BUCKET}

# 4. Get credentials
gcloud iam service-accounts keys create credentials-velero \
    --iam-account $SERVICE_ACCOUNT_EMAIL
# Put credentials-velero to cred/
### See for corect link [here.](https://github.com/vmware-tanzu/velero/releases/)
```
# Install velero
```sh 
# 1. Get velero
wget https://github.com/vmware-tanzu/velero/releases/download/v1.7.0/velero-v1.7.0-linux-amd64.tar.gz
# tar that archive and copy binary to /usr/local/bin/
# check version

# 2. Install velero
velero install \
    --provider gcp \
    --plugins velero/velero-plugin-for-gcp:v1.3.0 \
    --bucket $BUCKET \
    --secret-file ./credentials-velero

# 3. Create secret
kubectl create secret generic -n velero bsl-credentials --from-file=gcp=./credentials-velero

# 4. Create storage location
velero backup-location create mygcp \
  --provider gcp \
  --bucket $BUCKET \
  --credential=bsl-credentials=gcp

# check
velero backup-location get
```
# Simple backup commands
```sh
# 1. Create backup
velero backup create my-namespace-backup --include-namespaces default --wait

# 2. Get backups lists
velero backup get 

# 3. Describe backup
velero backup describe my-namespace-backup

# 4. Restore from backup
velero restore create my-namespace-restore --from-backup my-namespace-backup
# You need to add annotation, when migrate between different clusters!!!!!!!!!
```

```

