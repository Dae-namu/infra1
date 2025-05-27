terraform import aws_iam_role.cluster daenamu-test-eks-cluster-role || true
terraform import aws_iam_role.node_group daenamu-test-node-group-role || true
terraform import aws_iam_instance_profile.node_group daenamu-test-node-group-instance-profile || true
terraform import aws_iam_role.alb_sa_role AmazonEKSLoadBalancerControllerRole || true
terraform import aws_iam_policy.alb_policy arn:aws:iam::${AWS_ACCOUNT_ID}:policy/AWSLoadBalancerControllerIAMPolicy || true


terraform apply --auto-approve \
  -target=aws_iam_role.cluster \
  -target=aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy \
  -target=aws_iam_role_policy_attachment.cluster_AmazonEKSVPCResourceController \
  -target=aws_iam_role.pod_execution \
  -target=aws_iam_role_policy_attachment.pod_execution_AmazonEKSFargatePodExecutionRolePolicy \
  -target=aws_iam_role.node_group \
  -target=aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy \
  -target=aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy \
  -target=aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly
