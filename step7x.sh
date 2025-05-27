terraform destroy --auto-approve \
  -target=helm_release.jaeger \
  -target=kubernetes_manifest.ingress_gateway_vs \
  -target=kubectl_manifest.jaeger_virtualservice
