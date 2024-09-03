variable "region" {
  description = "The region to deploy resources"
  type        = string
  default     = "us-central1"
}

data "google_client_config" "default" {}

# Google provider configuration
provider "google" {
  project = "impactful-shard-429011-e7"
  region  = var.region
}

# Store the cluster endpoint, certificate, and access token data for later use
locals {
  cluster_endpoint       = google_container_cluster.shortlet-cluster.endpoint
  cluster_ca_certificate = base64decode(google_container_cluster.shortlet-cluster.master_auth[0].cluster_ca_certificate)
  cluster_token          = data.google_client_config.default.access_token
}

# Kubernetes provider configuration
provider "kubernetes" {
  host                   = local.cluster_endpoint
  token                  = local.cluster_token
  cluster_ca_certificate = local.cluster_ca_certificate
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

# Resourse responsible for a Kubernetes Deployment
resource "kubernetes_deployment" "shortlet-task-api-server-deployment" {
  depends_on = [google_container_cluster.shortlet-cluster]

  metadata {
    name      = "shortlet-task-api-server-deployment"
    namespace = "default"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        kind = "pod"
        app  = "shortlet-task-api-server"
      }
    }

    template {
      metadata {
        labels = {
          kind = "pod"
          app  = "shortlet-task-api-server"
        }
      }

      spec {
        container {
          image = "prince2006/shortlet-task:latest"
          name  = "shortlet-task-api-server"

          port {
            container_port = 5000
          }
        }
      }
    }
  }
}

# Resourse responsible for creaing a Kubernetes Service
resource "kubernetes_service" "shortlet-task-api-server-service" {
  depends_on = [google_container_cluster.shortlet-cluster, kubernetes_deployment.shortlet-task-api-server-deployment]

  metadata {
    name      = "shortlet-task-api-server-service"
    namespace = "default"
  }

  spec {
    selector = {
      kind = "pod"
      app  = "shortlet-task-api-server"
    }

    port {
      port        = 5000
      target_port = 5000
      protocol    = "TCP"
    }

    type = "LoadBalancer"
  }
}
