resource "google_compute_instance" "this" {
  name         = var.name
  zone         = var.zone
  machine_type = "e2-standard-2"
  tags         = ["ssh-access"]

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/family/debian-12"
      size  = 20
      type  = "pd-balanced"
    }
  }

  network_interface {
    subnetwork = var.subnet_id

    access_config {
      # Enables internet access
    }
  }

  metadata = {
    ssh-keys = "terraform:${file("~/.ssh/id_rsa_test.pub")}"

    startup-script = <<-EOF
      #!/bin/bash
      set -eux
      exec > /var/log/startup-ssh-port.log 2>&1

      NEW_PORT=${var.ssh_port}
      SSHD_CONFIG="/etc/ssh/sshd_config"

      # Idempotency: do nothing if already applied
      if grep -q "^Port $${NEW_PORT}" "$SSHD_CONFIG"; then
        echo "SSH already on port $${NEW_PORT}"
        exit 0
      fi

      cp "$SSHD_CONFIG" "$SSHD_CONFIG.bak.$(date +%F_%T)"

      sed -i '/^\\s*Port\\s\\+/d' "$SSHD_CONFIG"
      echo "Port $${NEW_PORT}" >> "$SSHD_CONFIG"

      sshd -t

      systemctl restart ssh || systemctl restart sshd

      echo "SSH port changed to $${NEW_PORT}"
    EOF
  }
}

