# Controll
variable "project_id" { default = "test1508" }

## Service account
variable "vmsa" { default = "ihor1test" }                                            # manualy created
variable "email" { default = "sa-terraform@test1508.iam.gserviceaccount.com" }

## Buckets
variable "bucket" { default = "terraform-bucket-1712" }

## Config 
variable "path_cred" { default = "./cred/" }
variable "region" { default = "us-central1" }
variable "zone" { default = "us-central1-c" }
variable "terraform-cred" { default = "cred/credterraform.json" } # Hen or egg ? # Owner access



# VM config
## Image
variable "image" { default = "ubuntu-os-cloud/ubuntu-2004-lts" }

## VM's count 
variable "master-count" { default = 1 }
variable "instance-count" { default = 2 }
variable "db-count" { default = 2 }

## VM type 
variable "machine" { # List
  type = map(any)    # of
  default = {        # Virtual Machines
    "slave"   = "n2d-highcpu-2"
    "master"  = "n2-standard-2"
    "bastion" = "e2-standard-2"
    "db"      = "e2-small"
  }
}

# State
variable "status-bastion" { default = "RUNNING" }
variable "status-master" { default = "RUNNING" }
variable "status-slaves" { default = "RUNNING" }
