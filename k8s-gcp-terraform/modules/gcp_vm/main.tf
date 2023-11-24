locals {
  name = "${var.project_name}-${var.environment}"
  labels = {
    "project" : var.project_name
    "environment" : var.environment
    "author" : "terraform"
  }
  instance_count = var.instance_count != 1 && var.network_ip == "" ? var.instance_count : 1
}
resource "google_compute_instance" "this" {
  count        = local.instance_count
  name         = local.instance_count == 1 ? "${local.name}-${var.name}-vm" : "${local.name}-${var.name}-${count.index}-vm"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      type  = "pd-ssd"
      image = var.image
      size  = var.disk_boot_size
    }
    auto_delete = true
  }
  network_interface {
    subnetwork = var.subnetwork
    dynamic "access_config" {
      for_each = var.external_ip != "" ? [1] : []
      content {
        nat_ip = var.external_ip
      }
    }
    network_ip = var.network_ip
  }

  metadata = {
    ssh-keys = var.username != "" && var.ssh_key != "" ? "${var.username}:${file(var.ssh_key)}" : null
  }
  metadata_startup_script = var.startup_script != "" ? file(var.startup_script) : null
  labels = merge(
    local.labels,
    {
      "name" : "${local.name}-${var.name}-vm"
  })
  allow_stopping_for_update = true
  tags                      = var.tags
}