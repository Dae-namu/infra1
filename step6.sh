aws eks update-kubeconfig --name daenamu-test --region ap-northeast-2
terraform apply --auto-approve \
 -target=helm_release.aws_load_balancer_controller \
 -target=kubernetes_service_account.alb_sa \
  -target=kubernetes_namespace.istio_system \
  -target=helm_release.istio_base \
  -target=helm_release.istiod \
  -target=helm_release.istio_ingress \
  -target=helm_release.metrics_server
  
