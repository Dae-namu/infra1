aws eks update-kubeconfig --name daenamu-test --region ap-northeast-2
terraform apply --auto-approve \
  -target=helm_release.jaeger \
  -target=kubernetes_manifest.ingress_gateway_vs \
  -target=kubernetes_manifest.istio_ingress_gateway \
  -target=kubernetes_ingress_v1.istio_gateway_ingress \
  -target=helm_release.cluster_autoscaler