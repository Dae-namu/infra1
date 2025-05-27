#!/bin/bash
echo "💻 Step 5: Node Group 생성"
terraform apply --auto-approve -target=aws_eks_node_group.this
