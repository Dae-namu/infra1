

# istio-system 네임스페이스 생성
resource "kubernetes_namespace" "istio_system" {
  metadata {
    name = "istio-system"
  }
}

# 1. istio-base 설치 (CRDs)
resource "helm_release" "istio_base" {
  name       = "istio-base"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "base"
  namespace  = kubernetes_namespace.istio_system.metadata[0].name
}

# 2. istiod 설치
resource "helm_release" "istiod" {
  name       = "istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  namespace  = kubernetes_namespace.istio_system.metadata[0].name

  depends_on = [helm_release.istio_base]

  set {
    name  = "global.istioNamespace"
    value = "istio-system"
  }

  set {
    name  = "meshConfig.enablePrometheusMerge"
    value = "true"
  }

  set {
  name  = "resources.requests.memory"
  value = "512Mi"
}

  set {
    name  = "pilot.traceSampling"
    value = "100.0"
  }

  set {
    name  = "values.global.proxy.autoInject"
    value = "enabled"
  }

  set {
  name  = "values.tracing.enabled"
  value = "true"
}
 set {
    name  = "collector.zipkin.hostPort"
    value = "9411"
  }

set {
  name  = "values.global.tracer.zipkin.address"
  value = "jaeger-collector.istio-system.svc.cluster.local:9411"
}


  
}



# 3. Ingress Gateway 설치 (선택)
resource "helm_release" "istio_ingress" {
  name       = "istio-ingressgateway"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "gateway"
  namespace  = kubernetes_namespace.istio_system.metadata[0].name

  depends_on = [helm_release.istiod]

  set {
    name  = "global.istioNamespace"
    value = "istio-system"
  }
}



