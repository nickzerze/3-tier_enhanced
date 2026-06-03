# Public ALB Security Group
resource "aws_security_group" "public_alb" {
  name        = "${var.project_name}-${var.environment}-public-alb-sg"
  description = "Allow HTTP and HTTPS from Internet"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from Internet - redirected to HTTPS"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from Internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound to web tier"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-public-alb-sg"
    Environment = var.environment
  }
}

# Web tier Security Group 
resource "aws_security_group" "web" {
  name        = "${var.project_name}-${var.environment}-web-sg"
  description = "Allow traffic from public ALB to web tier"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "HTTP from public ALB"
    from_port       = var.web_port
    to_port         = var.web_port
    protocol        = "tcp"
    security_groups = [aws_security_group.public_alb.id]
  }

  egress {
    description = "Allow outbound from web tier"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-web-sg"
    Environment = var.environment
  }
}

# Internal ALB Security Group (accepts traffic from web tier, forwards to app tier)
resource "aws_security_group" "internal_alb" {
  name        = "${var.project_name}-${var.environment}-internal-alb-sg"
  description = "Allow traffic from web tier to internal ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "HTTP from web tier"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }

  egress {
    description = "Allow outbound to app tier"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-internal-alb-sg"
    Environment = var.environment
  }
}

# App tier Security Group (accepts traffic from internal ALB)
resource "aws_security_group" "app" {
  name        = "${var.project_name}-${var.environment}-app-sg"
  description = "Allow app traffic from internal ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "App traffic from internal ALB"
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.internal_alb.id]
  }

  egress {
    description = "Allow outbound from app tier"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-app-sg"
    Environment = var.environment
  }
}

# RDS Security Group (accepts traffic from app tier)
resource "aws_security_group" "rds" {
  name        = "${var.project_name}-${var.environment}-rds-sg"
  description = "Allow MySQL only from app tier"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "MySQL from app tier"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }

  egress {
    description = "Allow outbound from RDS"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-rds-sg"
    Environment = var.environment
  }
}