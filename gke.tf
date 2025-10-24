resource "google_container_cluster" "gke" {
    name = "cluster-gke"
    location = "europe-west1-b"
    remove_default_node_pool = true
    initial_node_count = 1
    network = google_compute_network.vpc.self_link
    subnetwork = google_compute_subnetwork.private.self_link
    networking_mode = "VPC_NATIVE"

    deletion_protection = false

    addons_config {
      http_load_balancing {
        disabled = true
      }
      horizontal_pod_autoscaling {
        disabled = true
      }
    }

    release_channel {
      channel = "REGULAR"
    }

    workload_identity_config {
      workload_pool = "${local.project_id}.svc.id.goog"
    }

    ip_allocation_policy {
      cluster_secondary_range_name = "k8s-pods"
      services_secondary_range_name = "k8s-services"
    }

    private_cluster_config {
      enable_private_nodes = true
      enable_private_endpoint = false
      master_ipv4_cidr_block = "192.168.0.0/28"
    }
  

    #Habilitar el acceso privado a la API de GKE unicamente desde la subred privada
    #master_authorized_networks_config {
    #  cidr_blocks {
    #    cidr_block = "10.0.0.0/18"
    #    display_name = "private-subnet"
    #  }
    #}
}

  data "google_container_cluster" "gke_info" {
  depends_on = [ google_container_cluster.gke ]
  name       = google_container_cluster.gke.name
  location   = google_container_cluster.gke.location
}