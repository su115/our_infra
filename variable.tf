variable "path" {default = "."} # path to folder with credential file
variable "image" {default = "ubuntu-os-cloud/ubuntu-2004-lts"} # image
variable "instance_count" {default = 2}
variable "master_count" {default = 1}
variable "region" {default = "us-central1"}
variable "db_count" {default = 1} 
variable "zone" {default = "us-central1-c"}

variable "machine" {                                     # List
  type = map                                             # of
  default = {                                            # Virtual Machines
    "slave"  = "n2d-highcpu-2"
    "master" = "n2-standard-2"
    "bastion" = "e2-standard-2"
    "db" = "e2-small"
  }
}
variable "project" {default = "stone-botany-329514"}
variable "terraform-bucket" {default="stone-botany-329514-bucket"}
