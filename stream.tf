resource "kubernetes_deployment" "stream" {
  metadata {
    name      = "stream"
    namespace = "default"
    labels = {
      app = "stream"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "stream"
      }
    }
    template {
      metadata {
        labels = {
          app = "stream"
        }
      }
      spec {
        container {
          name  = "stream"
          image = "745173969277.dkr.ecr.ap-northeast-2.amazonaws.com/daenamu:stream"
          image_pull_policy = "Always"
          port {
            container_port = 8003
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
          env {
            name = "aws.s3.access-key"
            value_from {
              secret_key_ref {
                name = "stream-secret"
                key  = "aws.s3.access-key"
              }
            }
          }
          env {
            name = "aws.s3.secret-key"
            value_from {
              secret_key_ref {
                name = "stream-secret"
                key  = "aws.s3.secret-key"
              }
            }
          }
          env {
            name = "aws.s3.session-token"
            value_from {
              secret_key_ref {
                name = "stream-secret"
                key  = "aws.s3.session-token"
              }
            }
          }
          env {
            name = "S3_BUCKET_NAME"
            value_from {
              secret_key_ref {
                name = "stream-secret"
                key  = "S3_BUCKET_NAME"
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "stream" {
  metadata {
    name = "stream"
  }
  spec {
    selector = {
      app = "stream"
    }
    port {
      port        = 8003
      target_port = 8003
    }
  }
}
