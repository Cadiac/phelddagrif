# Create new A and CNAME records
resource "digitalocean_domain" "default" {
  name = "sivu.website"
  ip_address = "${digitalocean_droplet.phelddagrif-dev.ipv4_address}"
}

resource "digitalocean_record" "CNAME-www" {
  domain = "${digitalocean_domain.default.name}"
  type = "CNAME"
  name = "www"
  value = "@"
}

resource "digitalocean_record" "CNAME-dev" {
  domain = "${digitalocean_domain.default.name}"
  type = "CNAME"
  name = "dev"
  value = "@"
}
