data "google_compute_zones" "this" {
  region  = var.region
  project = var.project_id
}