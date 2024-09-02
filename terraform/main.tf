variable "region" {
  description = "The region to deploy resources"
  type        = string
  default     = "us-central1"
}


provider "google" {
  project = "impactful-shard-429011-e7"
  region  = var.region
}

# Resourse responsible for creating the GKE Cluster
resource "google_container_cluster" "shortlet-cluster" {
  name             = "shortlet-cluster"
  location         = var.region
  enable_autopilot = true
  network          = "default"
  subnetwork       = "default"

  #Enable terraform delete the cluster
  deletion_protection = false

  # Private Cluster Configuration
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false

    # Control plane IP range for private endpoint
    master_ipv4_cidr_block = "10.0.0.0/28"
  }
}

# Use the existing default network
data "google_compute_network" "default" {
  name = "default"
}

# Resourse responsible for creating the Cloud Router
resource "google_compute_router" "cloud-router" {
  name    = "shortlet-router"
  network = data.google_compute_network.default.self_link
  region  = var.region
}

# Resourse responsible for creating the Cloud NAT
resource "google_compute_router_nat" "nat_gateway" {
  name   = "shortlet-nat"
  router = google_compute_router.cloud-router.name
  region = var.region

  # Automatically allocate external IPs for NAT
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
