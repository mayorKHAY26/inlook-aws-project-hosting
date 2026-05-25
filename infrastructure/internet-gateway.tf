resource "aws_internet_gateway" "inlook_igw" {
  vpc_id = aws_vpc.inlook_vpc.id

  tags = {
    Name        = "${var.project_name}-internet-gateway"
    Project     = "Inlook"
    Environment = var.environment
  }
}