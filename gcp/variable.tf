# Controll
variable "project_id" { default = "stone-botany-ihor" }

## Service account
variable "vmsa" { default = "ihor1test" }                                            # manualy created
variable "email" { default = "ihor1test@stone-botany-ihor.iam.gserviceaccount.com" } # manualy created

## Buckets
variable "bucket" {
  type = list(string)
  default = [
    "terraform-bucket-1511", # uniq buckets
    "velero-bucket-1511"     # var.bucket[1]
  ]
}

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

