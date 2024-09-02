provider "google" {
  project = "impactful-shard-429011-e7"
  region  = "us-central1"
}

# Ensures the Google K8s engine API is enabled
# resource "google_project_service" "kubernetes" {
#   service = "container.googleapis.com"
# }
# # Ensures the Google Cloud monitoring API is enabled
# resource "google_project_service" "monitoring" {
#   service = "monitoring.googleapis.com"
# }

# Resourse responsible for creating the GKE Cluster
resource "google_container_cluster" "shortlet-cluster" {
  name                = "shortlet-cluster"
  location            = "us-central1"
  enable_autopilot    = true
  deletion_protection = false
}

# # Resourse responsible for creating the alert policy for tracking the CPU utilization of the shortlet-task-server container
# resource "google_monitoring_alert_policy" "high-cpu" {
#   depends_on   = [google_container_cluster.shortlet-cluster, google_monitoring_notification_channel.onukwilip-email-notification, google_project_service.monitoring, google_project_service.kubernetes]
#   display_name = "Shortlet task container - CPU utilization"
#   combiner     = "OR"

#   # The conditions for the alert manager
#   conditions {
#     display_name = "Shortlet task container - CPU utilization"
#     condition_threshold {
#       filter          = "metric.type=\"kubernetes.io/container/cpu/utilization\" AND resource.type=\"k8s_container\" AND resource.label.container_name=\"shortlet-task-api-server\""
#       comparison      = "COMPARISON_GT"
#       duration        = "60s"
#       threshold_value = 0.0005

#       aggregations {
#         alignment_period   = "60s"
#         per_series_aligner = "ALIGN_MEAN"
#       }
#     }
#   }

#   # Sets the notification channels which the alerts will be forwarded to
#   notification_channels = [google_monitoring_notification_channel.onukwilip-email-notification.id]

#   # The documentation to be included in the alert
#   documentation {
#     content   = "This policy checks the CPU utilization of containers in the GKE cluster and triggers an alert if the average usage exceeds 0.05% over a minute."
#     mime_type = "text/markdown"
#   }

#   alert_strategy {
#     auto_close = true
#   }

#   project = "impactful-shard-429011-e7"
# }

# # Resource responsible for the creation of the notification channel for the alert
# resource "google_monitoring_notification_channel" "onukwilip-email-notification" {
#   display_name = "Email Notifications"
#   type         = "email"
#   labels = {
#     email_address = "onukwilip@gmail.com"
#   }
# }
