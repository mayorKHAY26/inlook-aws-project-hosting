resource "aws_route_table" "inlook_public_route_table" {
  vpc_id = aws_vpc.inlook_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.inlook_igw.id
  }

  tags = {
    Name        = "${var.project_name}-public-route-table"
    Project     = "Inlook"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "inlook_public_subnet_1_association" {
  subnet_id      = aws_subnet.inlook_public_subnet_1.id
  route_table_id = aws_route_table.inlook_public_route_table.id
}

resource "aws_route_table_association" "inlook_public_subnet_2_association" {
  subnet_id      = aws_subnet.inlook_public_subnet_2.id
  route_table_id = aws_route_table.inlook_public_route_table.id
}