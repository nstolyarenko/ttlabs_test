locals {
  vm_names = ["vpn", "db", "mon"]
}

module "instances" {
  source = "./modules/compute-instance"

  for_each = toset(local.vm_names)

  name         = each.key
  zone         = var.zone
  subnet_id    = google_compute_subnetwork.subnet.id
  ssh_port     = var.ssh_port
}