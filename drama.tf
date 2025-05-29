resource "kubernetes_deployment" "drama" {
  metadata {
    name      = "drama"
    namespace = "default"
    labels = {
      app = "drama"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "drama"
      }
    }
    template {
      metadata {
        labels = {
          app = "drama"
        }
      }
      spec {
        container {
          name  = "drama"
          image = "745173969277.dkr.ecr.ap-northeast-2.amazonaws.com/daenamu:drama"
          image_pull_policy = "Always"
          port {
            container_port = 8001
          }
          env {
            name = "DB_HOST"
            value_from {
              secret_key_ref {
                name = "stream-secret"
                key  = "DB_HOST"
              }
            }
          }
          env {
            name = "DB_USERNAME"
            value_from {
              secret_key_ref {
                name = "stream-secret"
                key  = "DB_USERNAME"
              }
            }
          }
          env {
            name = "DB_PASSWORD"
            value_from {
              secret_key_ref {
                name = "stream-secret"
                key  = "DB_PASSWORD"
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "drama" {
  metadata {
    name = "drama"
  }
  spec {
    selector = {
      app = "drama"
    }
    port {
      port        = 8001
      target_port = 8001
    }
  }
}

resource "kubernetes_manifest" "drama_gateway" {
  manifest = {
    apiVersion = "networking.istio.io/v1beta1"
    kind       = "Gateway"
    metadata = {
      name      = "drama-gateway"
      namespace = "istio-system"
    }
    spec = {
      selector = {
        istio = "ingressgateway"
      }
      servers = [{
        port = {
          number   = 80
          name     = "http"
          protocol = "HTTP"
        }
        hosts = ["graderevive.net"]
      }]
    }
  }
}


resource "kubernetes_ingress_v1" "drama_ingress" {
  metadata {
    name      = "drama-ingress"
    namespace = "istio-system" 
    annotations = {
      "kubernetes.io/ingress.class"                        = "alb"
      "alb.ingress.kubernetes.io/scheme"                   = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"              = "ip"
      "alb.ingress.kubernetes.io/listen-ports"             = "[{\"HTTP\":80}]"
    }
  }

  spec {
    ingress_class_name = "alb"
    rule {
      host = "graderevive.net"
      http {
        path {
          path      = "/dramas"
          path_type = "Prefix"
          backend {
            service {
              name = "istio-ingressgateway"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_manifest" "drama_virtualservice" {
  manifest = {
    apiVersion = "networking.istio.io/v1beta1"
    kind       = "VirtualService"
    metadata = {
      name      = "drama-route"
      namespace = "default"
    }
    spec = {
      hosts    = ["graderevive.net"]
      gateways = ["istio-system/drama-gateway"]
      http = [{
        match = [{ uri = { prefix = "/dramas" } }]
        rewrite = {
          uri = "/"  # /dramas → / 로 리다이렉트
        }
        route = [{
          destination = {
            host = "drama.default.svc.cluster.local"
            port = {
              number = 8001
            }
          }
        }]
      }]
    }
  }
}
