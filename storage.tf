resource "kubernetes_storage_class" "balanced_wffc" {
  metadata {
    name = "balanced-wffc"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }

  storage_provisioner     = "kubernetes.io/gce-pd"
  volume_binding_mode     = "WaitForFirstConsumer"
  reclaim_policy          = "Delete"
  allow_volume_expansion  = true

  parameters = {
    type = "pd-balanced"
  }

  depends_on = [google_container_cluster.gke]
}
