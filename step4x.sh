# 클러스터 생성 이후에 가능한 IAM 리소스
terraform destroy --auto-approve \
  -target=aws_iam_openid_connect_provider.eks \
  -target=aws_iam_policy.alb_policy \
  -target=aws_iam_role.alb_sa_role \
  -target=aws_iam_role_policy_attachment.alb_policy_attach
