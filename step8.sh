# terraform apply --auto-approve \
#   -target=aws_iam_role.karpenter \
#   -target=aws_iam_role_policy_attachment.karpenter_extra \
#   -target=aws_iam_instance_profile.karpenter \
#   -target=aws_iam_role.karpenter_controller_role \
#   -target=aws_iam_policy.karpenter_controller_policy \
#   -target=aws_iam_role_policy_attachment.karpenter_policy_attach \
#   -target=helm_release.karpenter \
#   -target=null_resource.wait_for_karpenter \
#   -target=kubectl_manifest.karpenter_node_class \
#   -target=kubectl_manifest.karpenter_node_pool
