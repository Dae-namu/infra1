terraform apply --auto-approve -target=aws_eks_cluster.this

terraform import aws_iam_role.cluster daenamu-test-eks-cluster-role || true
terraform import aws_iam_role.node_group daenamu-test-node-group-role || true
terraform import aws_iam_instance_profile.node_group daenamu-test-node-group-instance-profile || true
terraform import aws_iam_role.alb_sa_role AmazonEKSLoadBalancerControllerRole || true
terraform import aws_iam_policy.alb_policy arn:aws:iam::${AWS_ACCOUNT_ID}:policy/AWSLoadBalancerControllerIAMPolicy || true


