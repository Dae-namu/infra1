resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  version    = "3.12.1"

  set {
    name  = "args"
    value = "{--kubelet-insecure-tls}"
  }

  set {
    name  = "priorityClassName"
    value = "system-cluster-critical"
  }
}
