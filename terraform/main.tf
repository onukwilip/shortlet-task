provider "google" {
  project = "impactful-shard-429011-e7"
  region  = "us-central1"
}

# Resourse responsible for creating the GKE Cluster
resource "google_container_cluster" "shortlet-cluster" {
  name                = "shortlet-cluster"
  location            = "us-central1"
  enable_autopilot    = true
  deletion_protection = false
}
