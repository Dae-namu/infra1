#nginx 삭제
terraform destroy --auto-approve \
  -target=kubernetes_deployment.nginx \
  -target=kubernetes_service.nginx \
  -target=kubernetes_ingress_v1.nginx_ingress
