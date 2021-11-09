data "terraform_remote_state" "network" {
  backend = "gcs"
  config = {
    bucket = var.bucket[0]
    prefix = "terraform/states/network"
  }
}

locals {
  vpc       = data.terraform_remote_state.network.outputs.vpc.self_link
  public-1  = data.terraform_remote_state.network.outputs.public-1.self_link
  private-1 = data.terraform_remote_state.network.outputs.private-1.self_link
  private-2 = data.terraform_remote_state.network.outputs.private-2.self_link

}

