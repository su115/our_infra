# CRAZY__TESTING
## Structure of our_infra
```sh
our_infra
├── ansible.log 
├── cred                # CREDENTIALS
│   ├── credterraform.json                          # sa-terraform service account
|   |                                               # give access to create infrastucture
│   ├── id_rsa                                      # keys for login on master, bastion, slaves
│   └── id_rsa.pub          
├── doc                 # DOCUMENTATION
│   ├── make.help                                   # Docs to Makefile
│   ├── README.dm                                   # Install and prepair our_infra
│   ├── ssh_tunnel.md                               # kubectl inside ssh_tunnel
│   └── velero.md                                   # Backups
├── gcp
│   ├── cluster         # INSTANCES ONLY
│   │   ├── bastion
│   │   │   ├── backend.tf                          # backend must be uniq
│   │   │   ├── bastion.tf
│   │   │   ├── cred -> ../../../cred       
│   │   │   ├── data.tf -> ../../data.tf    
│   │   │   ├── output.tf
│   │   │   └── variable.tf -> ../../variable.tf    
│   │   ├── master
│   │   │   ├── backend.tf                          # backend must be uniq
│   │   │   ├── cred -> ../../../cred       
│   │   │   ├── data.tf -> ../../data.tf    
│   │   │   ├── master.tf
│   │   │   ├── output.tf
│   │   │   ├── provider.tf -> ../../provider.tf   
│   │   │   └── variable.tf -> ../../variable.tf    
│   │   └── slaves
│   │       ├── backend.tf                          # backend must be uniq
│   │       ├── cred -> ../../../cred   
│   │       ├── data.tf -> ../../data.tf
│   │       ├── output.tf
│   │       ├── provider.tf -> ../../provider.tf
│   │       ├── slave.tf
│   │       └── variable.tf -> ../../variable.tf
│   ├── data.tf                                    
│   ├── network         # NETWORK
│   │   ├── backend.tf                              # backend must be uniq
│   │   ├── cred -> ../../cred/
│   │   ├── firewall.tf                         
│   │   ├── outputs.tf
│   │   ├── provider.tf -> ../provider.tf
│   │   ├── variable.tf -> ../variable.tf
│   │   └── vpc.tf                                  # subnets,routers,nat
│   ├── provider.tf
│   └── variable.tf                      # Change config of infra
├── kube-gcp            # ANSIBLE
│   ├── ansible.cfg
│   ├── ansible_install.sh
│   ├── files
│   │   ├── cloud-config                                    # GCP config && K8S
│   │   ├── default-gcp-storage-class.yaml                  # default StorageClass
│   │   └── gcp.yaml                                        # kubeadm InitConfiguration
│   ├── hosts                                               # hosts file
│   └── install-cluster.yml                                 # playbook to install k8s
├── Makefile            # Automatization manualy work
└── README.md           # this manual

```
