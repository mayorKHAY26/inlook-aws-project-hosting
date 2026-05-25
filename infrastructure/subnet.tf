resource "aws_subnet" "inlook_public_subnet_1" {
  vpc_id                  = aws_vpc.inlook_vpc.id
  cidr_block              = var.public_subnet_1_cidr
  availability_zone       = var.availability_zone_1
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_name}-public-subnet-1"
    Project     = "Inlook"
    Environment = var.environment
  }
}

resource "aws_subnet" "inlook_public_subnet_2" {
  vpc_id                  = aws_vpc.inlook_vpc.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = var.availability_zone_2
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_name}-public-subnet-2"
    Project     = "Inlook"
    Environment = var.environment
  }
}