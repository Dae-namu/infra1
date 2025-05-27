resource "helm_release" "kube_prometheus_stack" {
  name       = "kube-prometheus"
  namespace  = "monitoring"
  chart      = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  version    = "56.7.0"
  create_namespace = true

  values = [
    <<-EOT
    grafana:
      adminPassword: "test123"
      ingress:
        enabled: true
        ingressClassName: alb
        annotations:
          alb.ingress.kubernetes.io/scheme: internet-facing
          alb.ingress.kubernetes.io/target-type: ip
          alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}]'
          alb.ingress.kubernetes.io/backend-protocol: HTTP
        hosts:
          - "grafana.changal1234.com"
        path: /
        pathType: Prefix

    prometheus:
      ingress:
        enabled: true
        ingressClassName: alb
        annotations:
          alb.ingress.kubernetes.io/scheme: internet-facing
          alb.ingress.kubernetes.io/target-type: ip
          alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}]'
          alb.ingress.kubernetes.io/backend-protocol: HTTP
        hosts:
          - "prom.changal1234.com"
        path: /
        pathType: Prefix
    EOT
  ]
}
