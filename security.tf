resource "aws_security_group" "eks_nodes" {
  name        = "${local.cluster_name}-nodes-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.cluster_name}-nodes-sg"
    "karpenter.sh/discovery"                      = local.cluster_name
  }
}

resource "aws_security_group_rule" "allow_jaeger_ui" {
  type              = "ingress"
  from_port         = 16686
  to_port           = 16686
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.eks_nodes.id
}

resource "aws_security_group_rule" "allow_http_https" {
  type              = "ingress"
  from_port         = 80
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.eks_nodes.id
}

resource "aws_security_group_rule" "allow_backend_8001" {
  type              = "ingress"
  from_port         = 8001
  to_port           = 8001
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.eks_nodes.id
}