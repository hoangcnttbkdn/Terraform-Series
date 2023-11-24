locals {
  zones = data.google_compute_zones.this.names

  tags = {
    "Environment" : "local"
    "Project" : var.project_id
  }
}