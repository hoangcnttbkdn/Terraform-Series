locals {
  name = "${var.project_name}-${var.environment}"
  labels = {
    "project" : var.project_name
    "environment" : var.environment
    "author" : "terraform"
  }
}

resource "google_compute_network" "vpc" {
  name                            = "${local.name}-vpc"
  project                         = var.project
  delete_default_routes_on_create = false
  auto_create_subnetworks         = false
  routing_mode                    = "REGIONAL"
}

resource "google_compute_router" "vpc_router" {
  name    = "${local.name}-router"
  project = var.project
  region  = var.region
  network = google_compute_network.vpc.self_link
}

resource "google_compute_subnetwork" "vpc_public_subnetwork" {
  count                    = length(var.public_cidr_range)
  name                     = "${local.name}-public-subnetwork-${count.index}"
  region                   = var.region
  network                  = google_compute_network.vpc.self_link
  private_ip_google_access = true
  ip_cidr_range            = var.public_cidr_range[count.index]
}

resource "google_compute_subnetwork" "vpc_private_subnetwork" {
  count         = length(var.private_cidr_range)
  name          = "${local.name}-private-subnetwork-${count.index}"
  region        = var.region
  network       = google_compute_network.vpc.self_link
  ip_cidr_range = var.private_cidr_range[count.index]
  purpose       = "PRIVATE"
}

resource "google_compute_router_nat" "vpc_nat" {
  name                               = "${local.name}-nat"
  nat_ip_allocate_option             = "AUTO_ONLY"
  router                             = google_compute_router.vpc_router.name
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  region                             = var.region
  subnetwork {
    name                    = one(google_compute_subnetwork.vpc_private_subnetwork.*.self_link)
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}
