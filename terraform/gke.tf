resource "google_service_account" "gke" {
  account_id   = "telus-demo-service-account"
  display_name = "Telus Demo Service Account"
  project  = "cloud-app-test-359415"
}

resource "google_project_iam_member" "allow_image_pull" {
  project = "cloud-app-test-359415"
  role   = "roles/artifactregistry.admin"
  member = "serviceAccount:telus-demo-service-account@cloud-app-test-359415.iam.gserviceaccount.com"
}

resource "google_container_cluster" "primary" {
  name     = "telus-demo-gke-cluster"
  location = "us-central1"
  project  = "cloud-app-test-359415"

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  initial_node_count       = 1
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "small-node-pool"
  location   = "us-central1"
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-medium"

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.gke.email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
}

resource "kubernetes_namespace" "dev" {
  metadata {
    annotations = {
      name = "dev"
    }

    name = "dev"
  }
}

resource "kubernetes_namespace" "prod" {
  metadata {
    annotations = {
      name = "prod"
    }

    name = "prod"
  }
}