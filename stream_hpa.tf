resource "kubernetes_horizontal_pod_autoscaler_v2" "stream_hpa" {
  metadata {
    name      = "stream-hpa"
    namespace = "default"
  }

  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = "stream"
    }

    min_replicas = 1
    max_replicas = 3

    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type                = "Utilization"
          average_utilization = 40
        }
      }
    }
  }

  # depends_on = [
  #   kubernetes_manifest.stream  # YAML을 manifest로 썼을 경우
  # ]
}
