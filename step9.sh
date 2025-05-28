# terraform apply --auto-approve \
#   -target=kubernetes_deployment.daenamu_api \
#   -target=kubernetes_service.daenamu_api \
#   -target=kubernetes_ingress_v1.daenamu_api_ingress \
#   -target=kubernetes_deployment.nginx \
#   -target=kubernetes_service.nginx \
#   -target=kubernetes_ingress_v1.nginx_ingress \