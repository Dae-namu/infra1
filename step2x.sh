terraform destroy --auto-approve \
  -target=aws_iam_role.cluster \
  -target=aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy \
  -target=aws_iam_role_policy_attachment.cluster_AmazonEKSVPCResourceController \
  -target=aws_iam_role.pod_execution \
  -target=aws_iam_role_policy_attachment.pod_execution_AmazonEKSFargatePodExecutionRolePolicy \
  -target=aws_iam_role.node_group \
  -target=aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy \
  -target=aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy \
  -target=aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly
