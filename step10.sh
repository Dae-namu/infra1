terraform apply -target=helm_release.kube_prometheus_stack --auto-approve \
    -target=kubernetes_horizontal_pod_autoscaler_v2.stream_hpa --auto-approve