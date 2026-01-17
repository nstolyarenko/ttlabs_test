resource "google_compute_firewall" "ssh_non_standard" {
  name    = "allow-ssh-2222"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = [var.ssh_port]
  }

  source_ranges = var.ssh_cidr
  target_tags   = ["ssh-access"]
}
