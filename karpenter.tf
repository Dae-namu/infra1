# # EC2 런타임 역할
# resource "aws_iam_role" "karpenter" {
#   name = "karpenter-controller-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         },
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })
# }


# resource "aws_iam_instance_profile" "karpenter" {
#   name = "karpenter-instance-profile"
#   role = aws_iam_role.karpenter.name
# }







# # Helm 설치
# resource "helm_release" "karpenter" {
#   name             = "karpenter"
#   namespace        = "kube-system"
#   repository       = "oci://public.ecr.aws/karpenter"
#   chart            = "karpenter"
#   version          = "1.0.0"
#   wait             = true
#   create_namespace = false

#   values = [
#     <<-EOT
#     replicaCount: 1
#     serviceAccount:
#       create: true
#       name: karpenter
#       annotations:
#         eks.amazonaws.com/role-arn: ${aws_iam_role.karpenter_controller_role.arn}
#     settings:
#       clusterName: ${aws_eks_cluster.this.name}
#       clusterEndpoint: ${aws_eks_cluster.this.endpoint}
#       aws:
#         defaultInstanceProfile: ${aws_iam_instance_profile.karpenter.name}
#     EOT
#   ]

#   depends_on = [aws_iam_role_policy_attachment.karpenter_policy_attach]
# }

# # Pod 준비 대기
# resource "null_resource" "wait_for_karpenter" {
#   provisioner "local-exec" {
#     command = <<-EOT
#       for i in {1..30}; do
#         ready=$(kubectl get pod -n kube-system -l app.kubernetes.io/name=karpenter -o jsonpath='{.items[0].status.containerStatuses[0].ready}' 2>/dev/null)
#         if [ "$ready" = "true" ]; then
#           echo "Karpenter is ready"
#           exit 0
#         fi
#         echo "Waiting for Karpenter..."
#         sleep 5
#       done
#       echo "Karpenter did not become ready in time"
#       exit 1
#     EOT
#   }
#   depends_on = [helm_release.karpenter]
# }

# # NodeClass
# resource "kubectl_manifest" "karpenter_node_class" {
#   yaml_body = <<-YAML
#     apiVersion: karpenter.k8s.aws/v1beta1
#     kind: EC2NodeClass
#     metadata:
#       name: default
#     spec:
#       amiFamily: AL2
#       instanceProfile: ${aws_iam_instance_profile.karpenter.name}
#       subnetSelectorTerms:
#         - tags:
#             karpenter.sh/discovery: ${aws_eks_cluster.this.name}
#       securityGroupSelectorTerms:
#         - tags:
#             karpenter.sh/discovery: ${aws_eks_cluster.this.name}
#       tags:
#         karpenter.sh/discovery: ${aws_eks_cluster.this.name}
#   YAML
#   depends_on = [null_resource.wait_for_karpenter]
# }

# # NodePool
# resource "kubectl_manifest" "karpenter_node_pool" {
#   yaml_body = <<-YAML
#     apiVersion: karpenter.sh/v1beta1
#     kind: NodePool
#     metadata:
#       name: default
#     spec:
#       template:
#         spec:
#           nodeClassRef:
#             name: default
#           requirements:
#             - key: "karpenter.k8s.aws/instance-category"
#               operator: In
#               values: ["t", "c", "m", "r"]
#             - key: "karpenter.k8s.aws/instance-cpu"
#               operator: Gt
#               values: ["4"]
#             - key: "karpenter.k8s.aws/instance-hypervisor"
#               operator: In
#               values: ["nitro"]
#             - key: "karpenter.k8s.aws/instance-generation"
#               operator: Gt
#               values: ["2"]
#       limits:
#         cpu: 64
#       disruption:
#         consolidationPolicy: WhenEmpty
#         consolidateAfter: 30s
#   YAML
#   depends_on = [kubectl_manifest.karpenter_node_class]
# }


# resource "kubernetes_manifest" "karpenter_provisioner" {
#   manifest = {
#     "apiVersion" = "karpenter.sh/v1alpha5"
#     "kind"       = "Provisioner"
#     "metadata" = {
#       "name" = "default"
#     }
#     "spec" = {
#       "requirements" = [
#         {
#           "key"      = "kubernetes.io/arch"
#           "operator" = "In"
#           "values"   = ["amd64"]
#         }
#       ]
#       "limits" = {
#         "resources" = {
#           "cpu" = "1000"
#         }
#       }
#       "provider" = {
#         "subnetSelector" = {
#           "karpenter.sh/discovery" = local.cluster_name
#         }
#         "securityGroupSelector" = {
#           "karpenter.sh/discovery" = local.cluster_name
#         }
#       }
#       "ttlSecondsAfterEmpty" = 30
#     }
#   }
# }
