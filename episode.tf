resource "kubernetes_deployment" "episode" {
  metadata {
    name      = "episode"
    namespace = "default"
    labels = {
      app = "episode"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "episode"
      }
    }
    template {
      metadata {
        labels = {
          app = "episode"
        }
      }
      spec {
        container {
          name  = "episode"
          image = "745173969277.dkr.ecr.ap-northeast-2.amazonaws.com/daenamu:episode"
          image_pull_policy = "Always"
          port {
            container_port = 8002
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

resource "kubernetes_service" "episode" {
  metadata {
    name = "episode"
  }
  spec {
    selector = {
      app = "episode"
    }
    port {
      port        = 8002
      target_port = 8002
    }
  }
}