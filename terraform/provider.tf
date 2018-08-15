variable "do_token" {}
variable "pub_key" {}
variable "pvt_key" {}
variable "ssh_fingerprint" {}
variable "deploy_password" {}
variable "db_password" {}

provider "digitalocean" {
  token = "${var.do_token}"
}
