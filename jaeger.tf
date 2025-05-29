resource "helm_release" "jaeger" {
  name       = "jaeger"
  repository = "https://jaegertracing.github.io/helm-charts"
  chart      = "jaeger"
  namespace  = "istio-system"
  version    = "0.71.3"

  set {
    name  = "collector.enabled"
    value = "true"
  }

  set {
    name  = "query.enabled"
    value = "true"
  }

  set {
  name  = "query.replicas"
  value = "1"
}

set {
  name  = "query.resources.requests.memory"
  value = "256Mi"
}


  set {
    name  = "agent.enabled"
    value = "false"
  }

  set {
    name  = "storage.type"
    value = "memory"
  }

  set {
    name  = "cassandra.enabled"
    value = "false"
  }

  set {
    name  = "service.type"
    value = "ClusterIP"
  }
}

resource "kubernetes_manifest" "ingress_gateway_vs" {
  manifest = {
    apiVersion = "networking.istio.io/v1beta1"
    kind       = "VirtualService"
    metadata = {
      name      = "app-ingress"
      namespace = "istio-system"
    }
    spec = {
      hosts    = ["jaeger.graderevive.net"]
      gateways = ["istio-ingressgateway"]
      http = [
        {
          match = [{ uri = { prefix = "/" } }]
          route = [{
            destination = {
              host = "jaeger-query.istio-system.svc.cluster.local"
              port = { number = 80 }
            }
          }]
        }
        # {
        #   match = [{ uri = { prefix = "/" } }]
        #   route = [{
        #     destination = {
        #       host = "nginx-service.default.svc.cluster.local"
        #       port = { number = 80 }
        #     }
        #   }]
        # }
      ]
    }
  }
}