data "google_client_config" "default" {}

provider "google" {
    project = local.project_id
    region = local.region
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.gke_info.endpoint}"
  cluster_ca_certificate = base64decode(data.google_container_cluster.gke_info.master_auth[0].cluster_ca_certificate)
  token                  = data.google_client_config.default.access_token
}

provider "helm" {
  kubernetes {
    host                   = "https://${data.google_container_cluster.gke_info.endpoint}"
    cluster_ca_certificate = base64decode(data.google_container_cluster.gke_info.master_auth[0].cluster_ca_certificate)
    token                  = data.google_client_config.default.access_token
  }
}


terraform {
  required_version = ">= 1.0"

  required_providers {
    google = {
        source = "hashicorp/google"
        version = "~> 6.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.20.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.7.0"
    }
  }
}