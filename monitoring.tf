resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
    
  }
  depends_on = [google_container_cluster.gke]
}

// Deploy de Prometheus usando el chart de Prometheus Community
resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  
  
  set {
    name  = "server.persistentVolume.enabled"
    value = "true"
  }

  set {
    name  = "server.persistentVolume.storageClass"
    value = "balanced-wffc"
  }

  set {
    name  = "server.persistentVolume.size"
    value = "4Gi"
  }

  depends_on = [
    google_container_cluster.gke,
    kubernetes_namespace.monitoring,
    kubernetes_storage_class.balanced_wffc
  ]
}

// Deploy de Grafana usando el chart oficial de Grafana
resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  

  // Exponemos Grafana externamente via LoadBalancer y contraseña admin
  set {
    name  = "service.type"
    value = "LoadBalancer"
  }
  set {
    name  = "adminPassword"
    value = "admin"
  }
}
