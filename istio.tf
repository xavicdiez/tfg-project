resource "helm_release" "istio_base" {
  name       = "istio-base"
  namespace  = "istio-system"
  create_namespace = true

  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "base"
  version    = "1.25.2"
}

resource "helm_release" "istiod" {
  name       = "istiod"
  namespace  = "istio-system"

  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  version    = "1.25.2"

  depends_on = [helm_release.istio_base]

  set {
    name  = "global.meshID"
    value = "mesh1"
  }

  set {
    name  = "pilot.traceSampling"
    value = "100"
  }
}

resource "helm_release" "istio_ingress" {
  name       = "istio-ingressgateway"
  namespace  = "istio-system"

  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "gateway"
  version    = "1.25.2"

  depends_on = [helm_release.istiod]

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }
}

