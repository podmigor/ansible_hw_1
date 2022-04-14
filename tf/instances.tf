resource "tls_private_key" "test" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "google_secret_manager_secret" "ssh-key" {
  secret_id = "ssh-key"
  replication {
    automatic = true
  }
}

resource "google_compute_address" "static" {
  name = "vm-public-address"
  project = var.project
  region = var.region
  depends_on = [ module.network ]
}

resource "google_compute_instance" "ansible-runner" {
  name         = "ansible-runner"
  machine_type = "f1-micro"
  tags         = ["internal-ssh", "external-ssh"]
  zone = "europe-west2-a"

  boot_disk {
    initialize_params {
      image = "debian-10-buster-v20220317"
    }
  }
  network_interface {
    network = "ansible"
    subnetwork = "subnet-01"

    access_config {
      nat_ip = google_compute_address.static.address
    }
  }
  provisioner "remote-exec" {
    connection {
      host        = google_compute_address.static.address
      type        = "ssh"
      user        = var.user
      timeout     = "500s"
      private_key = tls_private_key.test.private_key_openssh
    }
    inline = [
      "sudo apt-get update && sudo apt-get install -y ansible git",
      "sudo chown ${var.user}:${var.user} /tmp/sshkey*",
      "git clone https://github.com/ahrechanychenko/ansible_demo.git"]
  }
  metadata = {
      ssh-keys = "${var.user}:${file(var.ssh_pub_key)}\n ${var.user}:${tls_private_key.test.public_key_openssh}"
    }
  metadata_startup_script = "ssh-keygen -b 2048 -t rsa -f /tmp/sshkey -q -N \"\" && gcloud secrets versions add ssh-key --data-file=\"/tmp/sshkey.pub\""
  depends_on   = [
    module.network, tls_private_key.test
  ]
  service_account {
    scopes = ["cloud-platform"]
  }
}

data "google_secret_manager_secret_version" "public_key" {
  secret    = "ssh-key"
  depends_on = [google_compute_instance.ansible-runner]
}

resource "google_compute_instance" "ansible-workers" {
  count = 3
  name         = "ansible-worker-${count.index}"
  machine_type = "f1-micro"
  tags         = ["internal-ssh"]
  zone = "europe-west2-a"
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "debian-10-buster-v20220317"
    }
  }
  network_interface {
    network = "ansible"
    subnetwork = "subnet-01"
    network_ip = "10.10.10.10${count.index}"

  }
  metadata = {
      ssh-keys = "${var.user}:${data.google_secret_manager_secret_version.public_key.secret_data}"
    }
  metadata_startup_script = "sudo apt-get update && sudo apt-get install -y python"
  depends_on   = [
    module.network, google_compute_instance.ansible-runner
  ]
  service_account {
    scopes = ["cloud-platform"]
  }
}

resource "local_file" "hosts_cfg" {
  content = templatefile("templates/hosts.tpl", {
    app1 = google_compute_instance.ansible-workers.0.network_interface.0.network_ip
    app2 = google_compute_instance.ansible-workers.1.network_interface.0.network_ip
  })
  filename = "./hosts.cfg"
}