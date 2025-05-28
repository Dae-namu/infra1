terraform apply --auto-approve \
  -target=kubernetes_deployment.daenamu_api \
  -target=kubernetes_service.daenamu_api \
  -target=kubernetes_ingress_v1.daenamu_api_ingress
