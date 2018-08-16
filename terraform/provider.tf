variable "do_token" {}
variable "pub_key" {}
variable "pvt_key" {}
variable "ssh_fingerprint" {}

variable "staging_password" {}
variable "staging_db_password" {}

variable "production_password" {}
variable "production_db_password" {}

variable "secret_key_base" {}

provider "digitalocean" {
  token = "${var.do_token}"
}
