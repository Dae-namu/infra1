# ALB Controller가 사용할 Kuvernetes서비스 어카운트 생성
resource "kubernetes_service_account" "alb_sa" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.alb_sa_role.arn
    }
  }
}

# helm_alb_controller.tf설치
resource "helm_release" "aws_load_balancer_controller" {
    depends_on = [
    aws_eks_cluster.this,
    aws_eks_node_group.this,
    kubernetes_service_account.alb_sa
  ]
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.6.1"

# ALB Controller가 사용할 EKS 클러스터 이름
  set {
    name  = "clusterName"
    value = local.cluster_name
  }

# ALB Controller가 동작할 VPC의 ID
  set {
    name  = "vpcId"
    value = aws_vpc.this.id
  }

# 서비스 어카운트를 Helm차트에서 생성하지 않도록 설정 (Terraform에서 미리 생성함)
  set {
    name  = "serviceAccount.create"
    value = "false"
  }

# 사용할 서비스 어카운트 이름 명시
  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }
}

# resource "kubectl_manifest" "jaeger_virtualservice" {
#   yaml_body = <<-YAML
#     apiVersion: networking.istio.io/v1beta1
#     kind: VirtualService
#     metadata:
#       name: jaeger-vs
#       namespace: istio-system
#     spec:
#       gateways:
#         - istio-ingressgateway
#       hosts:
#         - "jaeger.changal1234.com" 
#       http:
#         - match:
#             - uri:
#                 prefix: /jaeger
#           rewrite:
#             uri: /
#           route:
#             - destination:
#                 host: jaeger-query.istio-system.svc.cluster.local
#                 port:
#                   number: 80
#   YAML
# }

resource "kubernetes_ingress_v1" "istio_gateway_ingress" {
  metadata {
    name = "istio-gateway-ingress"
    namespace = "istio-system"
    annotations = {
       "kubernetes.io/ingress.class"                        = "alb"
      "alb.ingress.kubernetes.io/scheme"                   = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"              = "ip"
      "alb.ingress.kubernetes.io/listen-ports"             = "[{\"HTTP\":80}]"
      # "alb.ingress.kubernetes.io/certificate-arn"          = "arn:aws:acm:ap-northeast-2:185098440662:certificate/ddb38465-35d5-4d32-ab63-c3ad3ba8506b"
      "alb.ingress.kubernetes.io/backend-protocol"         = "HTTP"
    }
  }

spec {
    ingress_class_name = "alb"
    rule {
      host = "jaeger.changal1234.com"  # 예: jaeger.aws9.pri
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "istio-ingressgateway"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [helm_release.aws_load_balancer_controller]
}

resource "kubernetes_manifest" "istio_ingress_gateway" {
  manifest = {
    apiVersion = "networking.istio.io/v1beta1"
    kind       = "Gateway"
    metadata = {
      name      = "istio-ingressgateway"
      namespace = "istio-system"
    }
    spec = {
      selector = {
        istio = "ingressgateway"
      }
      servers = [
  {
    port = {
      number   = 80
      name     = "http"
      protocol = "HTTP"
    }
    hosts = ["jaeger.changal1234.com"]
  },
  {
    port = {
      number   = 443
      name     = "https"
      protocol = "HTTPS"
    }
    tls = {
      mode           = "SIMPLE"
      credentialName = "jaeger-cert"
    }
    hosts = ["jaeger.changal1234.com"]
  }
]

    }
  }
}