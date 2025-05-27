echo "🔧 Terraform EKS 인프라 초기 리소스 생성 중..."

terraform destroy --auto-approve \
  -target=aws_vpc.this \
  -target=aws_subnet.public \
  -target=aws_subnet.private \
  -target=aws_internet_gateway.this \
  -target=aws_nat_gateway.this \
  -target=aws_route_table.public \
  -target=aws_route.public_worldwide \
  -target=aws_route_table_association.public \
  -target=aws_route_table.private \
  -target=aws_route.private_worldwide \
  -target=aws_route_table_association.private
