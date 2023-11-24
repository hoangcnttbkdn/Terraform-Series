module "vpc" {
  source             = "./modules/gcp_networking"
  environment        = var.environment
  project            = var.project_id
  region             = var.region
  project_name       = var.project_name
  public_cidr_range  = var.public_cidr_range
  private_cidr_range = var.private_cidr_range
}

resource "google_compute_address" "bastion_ip" {
  name = "${var.project_name}-bastion-ip"
}

module "bastion_host" {
  source         = "./modules/gcp_vm"
  name           = "bastion"
  environment    = var.environment
  project_name   = var.project_name
  zone           = "${var.region}-a"
  image          = "centos-cloud/centos-7"
  subnetwork     = one(module.vpc.public_subnetwork)
  external_ip    = google_compute_address.bastion_ip.address
  startup_script = "./files/k8s_bastion.sh"
  username       = var.username
  ssh_key        = "~/.ssh/id_rsa.pub"
  tags           = ["bastion"]
  region         = var.region
}
#
module "control_plane" {
  source         = "./modules/gcp_vm"
  name           = "control-plane"
  environment    = var.environment
  project_name   = var.project_name
  zone           = "${var.region}-a"
  machine_type   = "e2-medium"
  image          = "ubuntu-os-cloud/ubuntu-2004-focal-v20220712"
  subnetwork     = one(module.vpc.private_subnetwork)
  network_ip     = "10.0.16.2"
  startup_script = "./files/k8s_install_control_plane.sh"
  username       = var.username
  ssh_key        = "~/.ssh/id_rsa.pub"
  tags           = ["k8s-vm"]
  region         = var.region
}

module "worker" {
  source         = "./modules/gcp_vm"
  name           = "worker"
  environment    = var.environment
  project_name   = var.project_name
  zone           = "${var.region}-a"
  instance_count = 1
  machine_type   = "e2-medium"
  image          = "ubuntu-os-cloud/ubuntu-2004-focal-v20220712"
  subnetwork     = one(module.vpc.private_subnetwork)
  startup_script = "./files/k8s_install_worker_node.sh"
  username       = var.username
  ssh_key        = "~/.ssh/id_rsa.pub"
  tags           = ["k8s-vm"]
  region         = var.region
  depends_on     = [module.control_plane]
}