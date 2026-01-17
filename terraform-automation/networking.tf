resource "google_compute_network" "vpc" {
  name                    = "ttlabs-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "ttlabs-subnet"
  region        = var.region
  network       = google_compute_network.vpc.id
  ip_cidr_range = "10.22.0.0/24"
}
