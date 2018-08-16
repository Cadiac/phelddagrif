variable "do_token" {}
variable "pub_key" {}
variable "pvt_key" {}
variable "ssh_fingerprint" {}
variable "production_password" {}
variable "production_db_password" {}
variable "letsencrypt_email" {}
variable "secret_key_base" {}

provider "digitalocean" {
  token = "${var.do_token}"
}
