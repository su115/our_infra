data "terraform_remote_state" "network" {
  backend = "gcs"
  config = {
    bucket = var.bucket[0]
    prefix = "terraform/states/network"
  }
}

locals {
  vpc       = data.terraform_remote_state.network.outputs.vpc
  public-1  = data.terraform_remote_state.network.outputs.public-1
  private-1 = data.terraform_remote_state.network.outputs.private-1
  private-2 = data.terraform_remote_state.network.outputs.private-2

}

