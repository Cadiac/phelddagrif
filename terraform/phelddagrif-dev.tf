resource "digitalocean_droplet" "phelddagrif-dev" {
  image = "ubuntu-16-04-x64"
  name = "phelddagrif-dev"
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
      "wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb",
      "sudo dpkg -i erlang-solutions_1.0_all.deb",
      "sudo apt-get update",
      "sudo apt-get -y install build-essential",
      "sudo apt-get -y install git",
      # Install nginx
      "sudo apt-get -y install nginx",
      # Install erlang and elixir
      "sudo apt-get -y install esl-erlang",
      "sudo apt-get -y install elixir",
      # Add user for deployments and set its password
      "sudo adduser --disabled-password --gecos \"\" deploy",
      "echo \"deploy:${var.deploy_password}\"|chpasswd",
      "sudo usermod -aG sudo deploy",
      "sudo mkdir /home/deploy/.ssh",
      "sudo cp /root/.ssh/authorized_keys /home/deploy/.ssh/authorized_keys",
      "sudo chown deploy /home/deploy/.ssh/authorized_keys",
      # Disable root SSH login
      "sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config",
      "sudo service sshd restart"
    ]
	}
}
