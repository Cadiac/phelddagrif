resource "digitalocean_droplet" "phelddagrif" {
  image = "ubuntu-16-04-x64"
  name = "phelddagrif"
  region = "ams3"
  size = "1gb"
  ssh_keys = [
    "${var.ssh_fingerprint}"
  ]

	connection {
		user = "root"
		type = "ssh"
		private_key = "${file(var.pvt_key)}"
		timeout = "2m"
	}

  provisioner "file" {
    source = "nginx.conf"
    destination = "/tmp/nginx.conf"
  }

	provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      # Add repositories
      "wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb",
      "sudo add-apt-repository 'deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main'",
      "wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -",
      "sudo dpkg -i erlang-solutions_1.0_all.deb",
      "sudo add-apt-repository -y ppa:certbot/certbot",
      "sudo apt-get update",
      # "sudo apt-get -y upgrade",
      "sudo apt-get -y install build-essential",
      "sudo apt-get -y install git",
      # Install nginx
      "sudo apt-get -y install nginx",
      # Install erlang and elixir
      "sudo apt-get -y install esl-erlang",
      "sudo apt-get -y install elixir",
      # Install certbot for letsencrypt
      "sudo apt-get -y install python-certbot-nginx",
      # Add user for production deployments and set its password
      "sudo adduser --disabled-password --gecos '' production",
      "echo 'production:${var.production_password}'|chpasswd",
      "sudo usermod -aG sudo production",
      "sudo mkdir /home/production/.ssh",
      "sudo cp /root/.ssh/authorized_keys /home/production/.ssh/authorized_keys",
      "sudo chown production /home/production/.ssh/authorized_keys",
      # Setup firewall
      "sudo ufw allow OpenSSH",
      "sudo ufw allow 'Nginx Full'",
      "sudo ufw --force enable",
      # Install postgres
      "sudo apt-get -y install postgresql-10",
      # Create production database
      "sudo -u postgres psql -c \"CREATE DATABASE phelddagrif_prod;\"",
      "sudo -u postgres psql -c \"CREATE USER production WITH PASSWORD '${var.production_db_password}';\"",
      "sudo -u postgres psql -c \"GRANT ALL PRIVILEGES ON DATABASE phelddagrif_prod TO production;\"",
      # Install nodejs
      "curl -sL https://deb.nodesource.com/setup_8.x -o nodesource_setup.sh",
      "sudo bash nodesource_setup.sh",
      "sudo apt-get -y install nodejs",
      # Set environment variables for production environment
      "echo \"export LC_ALL=en_US.UTF-8\" >> /home/production/.profile",
      "echo \"export LANGUAGE=en_US.UTF\" >> /home/production/.profile",
      "echo \"export PORT=3000\" >> /home/production/.profile",
      "echo \"export DATABASE_URL=\"postgres://production:${var.production_db_password}@localhost/phelddagrif_prod\"\" >> /home/production/.profile",
      "echo \"export SECRET_KEY_BASE=${var.secret_key_base}\" >> /home/production/.profile",
      # Copy nginx config from tmp and replace the default site with it
      "cp /tmp/nginx.conf /etc/nginx/sites-available/default",
      # Restart nginx
      "sudo systemctl reload nginx",
      # Request SSL certificate. This has to be run after DNS provider has completed...
      "( sleep 300 ; sudo certbot --nginx -d phelddagrif.sivu.website --non-interactive --agree-tos --email ${var.letsencrypt_email} ) &",
      # Disable root SSH login
      "sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config",
      "sudo service sshd restart"
    ]
	}
}
