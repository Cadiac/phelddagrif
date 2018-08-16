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

	provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      # Add repositories
      "wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb",
      "sudo add-apt-repository 'deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main'",
      "wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -",
      "sudo dpkg -i erlang-solutions_1.0_all.deb",
      "sudo apt-get update",
      # "sudo apt-get -y upgrade",
      "sudo apt-get -y install build-essential",
      "sudo apt-get -y install git",
      # Install nginx
      "sudo apt-get -y install nginx",
      # Install erlang and elixir
      "sudo apt-get -y install esl-erlang",
      "sudo apt-get -y install elixir",
      # Add user for staging deployments and set its password
      "sudo adduser --disabled-password --gecos '' staging",
      "echo 'staging:${var.staging_password}'|chpasswd",
      "sudo usermod -aG sudo staging",
      "sudo mkdir /home/staging/.ssh",
      "sudo cp /root/.ssh/authorized_keys /home/staging/.ssh/authorized_keys",
      "sudo chown staging /home/staging/.ssh/authorized_keys",
      # Create directory for releases
      "sudo mkdir /home/staging/app_release",
      # Setup firewall
      "sudo ufw allow OpenSSH",
      "sudo ufw --force enable",
      # Install postgres
      "sudo apt-get -y install postgresql-10",
      # Create database
      "sudo -u postgres psql -c \"CREATE DATABASE phelddagrif_staging;\"",
      "sudo -u postgres psql -c \"CREATE USER staging WITH PASSWORD '${var.staging_db_password}';\"",
      "sudo -u postgres psql -c \"GRANT ALL PRIVILEGES ON DATABASE phelddagrif_staging TO staging;\"",
      # Install nodejs
      "curl -sL https://deb.nodesource.com/setup_8.x -o nodesource_setup.sh",
      "sudo bash nodesource_setup.sh",
      "sudo apt-get -y install nodejs",
      # Set environment variables for staging environment
      "echo \"export PORT=4000\" >> /home/staging/.profile",
      "echo \"export DATABASE_URL=\"postgres://staging:${var.staging_db_password}@localhost/phelddagrif_staging\"\" >> /home/staging/.profile",
      "echo \"export SECRET_KEY_BASE=${var.secret_key_base}\" >> /home/staging/.profile",
      # Disable root SSH login
      "sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config",
      "sudo service sshd restart"
    ]
	}
}
