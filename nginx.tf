# 백엔드 애플리케이션 Deployment
resource "kubernetes_deployment" "daenamu_api" {
  metadata {
    name = "daenamu-api-deployment"
    labels = {
      app = "daenamu-api"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "daenamu-api"
      }
    }

    template {
      metadata {
        labels = {
          app = "daenamu-api"
        }
      }

      spec {
        container {
          name  = "daenamu-api"
          image = "745173969277.dkr.ecr.ap-northeast-2.amazonaws.com/daenamu"
          port {
            container_port = 8001
          }
        }
      }
    }
  }
}

# 백엔드 Service
resource "kubernetes_service" "daenamu_api" {
  metadata {
    name = "daenamu-api-service"
    labels = {
      app = "daenamu-api"
    }
  }

  spec {
    selector = {
      app = "daenamu-api"
    }

    port {
      port        = 80
      target_port = 8001
    }

    type = "ClusterIP"
  }
}

# ALB Ingress 리소스
resource "kubernetes_ingress_v1" "daenamu_api_ingress" {
  metadata {
    name = "daenamu-api-ingress"
    annotations = {
      "kubernetes.io/ingress.class"                         = "alb"
      "alb.ingress.kubernetes.io/scheme"                    = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"               = "ip"
      "alb.ingress.kubernetes.io/listen-ports"              = "[{\"HTTP\":80}]"
      "alb.ingress.kubernetes.io/healthcheck-path"          = "/actuator/health"
      "alb.ingress.kubernetes.io/success-codes"             = "200"
      "alb.ingress.kubernetes.io/backend-protocol"          = "HTTP"
    }
  }

  spec {
    ingress_class_name = "alb"
    rule {
      http {
        path {
          path      = "/daenamu"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.daenamu_api.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_service.daenamu_api
  ]
}
