resource "google_compute_firewall" "bastion_fw" {
  name    = "${var.project_name}-allow-ssh-fw"
  network = module.vpc.network

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["bastion"]
}

resource "google_compute_firewall" "k8s_fw" {
  name    = "${var.project_name}-k8s-default-fw"
  network = module.vpc.network

  allow {
    protocol = "tcp"
    ports    = ["22", "6443", "10250", "443"]
  }

  source_ranges = ["10.0.0.0/16"]
  target_tags   = ["k8s-vm"]
}