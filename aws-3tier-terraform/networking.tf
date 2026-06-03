data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-vpc"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-${var.environment}-igw"
    Environment = var.environment
  }
}

# Public subnets
resource "aws_subnet" "public_az1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_az1_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-public-az1"
    Environment = var.environment
    Tier        = "public"
  }
}

resource "aws_subnet" "public_az2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_az2_cidr
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-public-az2"
    Environment = var.environment
    Tier        = "public"
  }
}

# Private subnets for web tier
resource "aws_subnet" "private_web_az1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_web_subnet_az1_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.project_name}-${var.environment}-private-web-az1"
    Environment = var.environment
    Tier        = "web"
  }
}

resource "aws_subnet" "private_web_az2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_web_subnet_az2_cidr
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.project_name}-${var.environment}-private-web-az2"
    Environment = var.environment
    Tier        = "web"
  }
}

# Private subnets for app tier
resource "aws_subnet" "private_app_az1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_app_subnet_az1_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.project_name}-${var.environment}-private-app-az1"
    Environment = var.environment
    Tier        = "app"
  }
}

resource "aws_subnet" "private_app_az2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_app_subnet_az2_cidr
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.project_name}-${var.environment}-private-app-az2"
    Environment = var.environment
    Tier        = "app"
  }
}

# Private subnets for database tier
resource "aws_subnet" "private_db_az1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_db_subnet_az1_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.project_name}-${var.environment}-private-db-az1"
    Environment = var.environment
    Tier        = "database"
  }
}

resource "aws_subnet" "private_db_az2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_db_subnet_az2_cidr
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.project_name}-${var.environment}-private-db-az2"
    Environment = var.environment
    Tier        = "database"
  }
}

# NAT gateways
resource "aws_eip" "nat_az1" {
  domain = "vpc"

  tags = {
    Name        = "${var.project_name}-${var.environment}-nat-eip-az1"
    Environment = var.environment
  }
}

resource "aws_eip" "nat_az2" {
  domain = "vpc"

  tags = {
    Name        = "${var.project_name}-${var.environment}-nat-eip-az2"
    Environment = var.environment
  }
}

resource "aws_nat_gateway" "az1" {
  allocation_id = aws_eip.nat_az1.id
  subnet_id     = aws_subnet.public_az1.id

  depends_on = [aws_internet_gateway.main]

  tags = {
    Name        = "${var.project_name}-${var.environment}-nat-az1"
    Environment = var.environment
  }
}

resource "aws_nat_gateway" "az2" {
  allocation_id = aws_eip.nat_az2.id
  subnet_id     = aws_subnet.public_az2.id

  depends_on = [aws_internet_gateway.main]

  tags = {
    Name        = "${var.project_name}-${var.environment}-nat-az2"
    Environment = var.environment
  }
}

# Route tables  
#   Public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-${var.environment}-public-rt"
    Environment = var.environment
  }
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public_az1" {
  subnet_id      = aws_subnet.public_az1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_az2" {
  subnet_id      = aws_subnet.public_az2.id
  route_table_id = aws_route_table.public.id
}

# Private route tables for AZ1
resource "aws_route_table" "private_az1" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-${var.environment}-private-rt-az1"
    Environment = var.environment
  }
}

resource "aws_route" "private_az1_nat_access" {
  route_table_id         = aws_route_table.private_az1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.az1.id
}

resource "aws_route_table_association" "private_web_az1" {
  subnet_id      = aws_subnet.private_web_az1.id
  route_table_id = aws_route_table.private_az1.id
}

resource "aws_route_table_association" "private_app_az1" {
  subnet_id      = aws_subnet.private_app_az1.id
  route_table_id = aws_route_table.private_az1.id
}

# Private route tables for AZ2
resource "aws_route_table" "private_az2" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-${var.environment}-private-rt-az2"
    Environment = var.environment
  }
}

resource "aws_route" "private_az2_nat_access" {
  route_table_id         = aws_route_table.private_az2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.az2.id
}

resource "aws_route_table_association" "private_web_az2" {
  subnet_id      = aws_subnet.private_web_az2.id
  route_table_id = aws_route_table.private_az2.id
}

resource "aws_route_table_association" "private_app_az2" {
  subnet_id      = aws_subnet.private_app_az2.id
  route_table_id = aws_route_table.private_az2.id
}

# Private route table for database subnets (no internet access)
resource "aws_route_table" "private_db" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-${var.environment}-private-db-rt"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "private_db_az1" {
  subnet_id      = aws_subnet.private_db_az1.id
  route_table_id = aws_route_table.private_db.id
}

resource "aws_route_table_association" "private_db_az2" {
  subnet_id      = aws_subnet.private_db_az2.id
  route_table_id = aws_route_table.private_db.id
}