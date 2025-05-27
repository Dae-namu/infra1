#!/bin/bash
echo "💻 Step 5: Node Group 삭제"
terraform destroy --auto-approve -target=aws_eks_node_group.this
