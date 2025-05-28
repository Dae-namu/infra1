# resource "kubernetes_horizontal_pod_autoscaler_v2" "daenamu_api_hpa" {
#   metadata {
#     name      = "daenamu-api-hpa"
#     namespace = "default"
#   }

#   spec {
#     scale_target_ref {
#       api_version = "apps/v1"
#       kind        = "Deployment"
#       name        = "daenamu-api-deployment"
#     }

#     min_replicas = 1
#     max_replicas = 5

#     metric {
#       type = "Resource"
#       resource {
#         name = "cpu"
#         target {
#           type                = "Utilization"
#           average_utilization = 40
#         }
#       }
#     }
#   }

# #   depends_on = [
# #     kubernetes_deployment.daenamu_api
# #   ]
# }
