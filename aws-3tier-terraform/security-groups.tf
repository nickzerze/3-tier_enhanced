# Αρχείο για τα Security Groups που ελέγχουν την επικοινωνία public ALB, web, internal ALB, app και RDS.

# Public ALB Security Group

# Δημιουργεί Security Group. Terraform όνομα: public_alb.
resource "aws_security_group" "public_alb" {
  # Ορίζει το όνομα του πόρου μέσα στην AWS.
  name        = "${var.project_name}-${var.environment}-public-alb-sg"
  # Περιγράφει τον σκοπό του πόρου.
  description = "Allow HTTP and HTTPS from Internet"
  # Συνδέει τον πόρο με το συγκεκριμένο VPC.
  vpc_id      = aws_vpc.main.id

  # Κανόνας εισερχόμενης κίνησης στο Security Group.
  ingress {
    # Περιγράφει τον σκοπό του πόρου.
    description = "HTTP from Internet - redirected to HTTPS"
    # Ορίζει την αρχική πόρτα του κανόνα.
    from_port   = 80
    # Ορίζει την τελική πόρτα του κανόνα.
    to_port     = 80
    # Ορίζει το πρωτόκολλο δικτύου, π.χ. tcp ή HTTP.
    protocol    = "tcp"
    # Ορίζει από ποια IP ranges επιτρέπεται η κίνηση.
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Κανόνας εισερχόμενης κίνησης στο Security Group.
  ingress {
    # Περιγράφει τον σκοπό του πόρου.
    description = "HTTPS from Internet"
    # Ορίζει την αρχική πόρτα του κανόνα.
    from_port   = 443
    # Ορίζει την τελική πόρτα του κανόνα.
    to_port     = 443
    # Ορίζει το πρωτόκολλο δικτύου, π.χ. tcp ή HTTP.
    protocol    = "tcp"
    # Ορίζει από ποια IP ranges επιτρέπεται η κίνηση.
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Κανόνας εξερχόμενης κίνησης από το Security Group.
  egress {
    # Περιγράφει τον σκοπό του πόρου.
    description = "Allow outbound to web tier"
    # Ορίζει την αρχική πόρτα του κανόνα.
    from_port   = 0
    # Ορίζει την τελική πόρτα του κανόνα.
    to_port     = 0
    # Ορίζει το πρωτόκολλο δικτύου, π.χ. tcp ή HTTP.
    protocol    = "-1"
    # Ορίζει από ποια IP ranges επιτρέπεται η κίνηση.
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Tags για οργάνωση, αναζήτηση και κοστολόγηση πόρων στην AWS.
  tags = {
    Name        = "${var.project_name}-${var.environment}-public-alb-sg"
    Environment = var.environment
  }
}

# Web tier Security Group 

# Δημιουργεί Security Group. Terraform όνομα: web.
resource "aws_security_group" "web" {
  # Ορίζει το όνομα του πόρου μέσα στην AWS.
  name        = "${var.project_name}-${var.environment}-web-sg"
  # Περιγράφει τον σκοπό του πόρου.
  description = "Allow traffic from public ALB to web tier"
  # Συνδέει τον πόρο με το συγκεκριμένο VPC.
  vpc_id      = aws_vpc.main.id

  # Κανόνας εισερχόμενης κίνησης στο Security Group.
  ingress {
    # Περιγράφει τον σκοπό του πόρου.
    description     = "HTTP from public ALB"
    # Ορίζει την αρχική πόρτα του κανόνα.
    from_port       = var.web_port
    # Ορίζει την τελική πόρτα του κανόνα.
    to_port         = var.web_port
    # Ορίζει το πρωτόκολλο δικτύου, π.χ. tcp ή HTTP.
    protocol        = "tcp"
    # Επιτρέπει κίνηση μόνο από τα συγκεκριμένα Security Groups.
    security_groups = [aws_security_group.public_alb.id]
  }

  # Κανόνας εξερχόμενης κίνησης από το Security Group.
  egress {
    # Περιγράφει τον σκοπό του πόρου.
    description = "Allow outbound from web tier"
    # Ορίζει την αρχική πόρτα του κανόνα.
    from_port   = 0
    # Ορίζει την τελική πόρτα του κανόνα.
    to_port     = 0
    # Ορίζει το πρωτόκολλο δικτύου, π.χ. tcp ή HTTP.
    protocol    = "-1"
    # Ορίζει από ποια IP ranges επιτρέπεται η κίνηση.
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Tags για οργάνωση, αναζήτηση και κοστολόγηση πόρων στην AWS.
  tags = {
    Name        = "${var.project_name}-${var.environment}-web-sg"
    Environment = var.environment
  }
}

# Internal ALB Security Group (accepts traffic from web tier, forwards to app tier)

# Δημιουργεί Security Group. Terraform όνομα: internal_alb.
resource "aws_security_group" "internal_alb" {
  # Ορίζει το όνομα του πόρου μέσα στην AWS.
  name        = "${var.project_name}-${var.environment}-internal-alb-sg"
  # Περιγράφει τον σκοπό του πόρου.
  description = "Allow traffic from web tier to internal ALB"
  # Συνδέει τον πόρο με το συγκεκριμένο VPC.
  vpc_id      = aws_vpc.main.id

  # Κανόνας εισερχόμενης κίνησης στο Security Group.
  ingress {
    # Περιγράφει τον σκοπό του πόρου.
    description     = "HTTP from web tier"
    # Ορίζει την αρχική πόρτα του κανόνα.
    from_port       = 80
    # Ορίζει την τελική πόρτα του κανόνα.
    to_port         = 80
    # Ορίζει το πρωτόκολλο δικτύου, π.χ. tcp ή HTTP.
    protocol        = "tcp"
    # Επιτρέπει κίνηση μόνο από τα συγκεκριμένα Security Groups.
    security_groups = [aws_security_group.web.id]
  }

  # Κανόνας εξερχόμενης κίνησης από το Security Group.
  egress {
    # Περιγράφει τον σκοπό του πόρου.
    description = "Allow outbound to app tier"
    # Ορίζει την αρχική πόρτα του κανόνα.
    from_port   = 0
    # Ορίζει την τελική πόρτα του κανόνα.
    to_port     = 0
    # Ορίζει το πρωτόκολλο δικτύου, π.χ. tcp ή HTTP.
    protocol    = "-1"
    # Ορίζει από ποια IP ranges επιτρέπεται η κίνηση.
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Tags για οργάνωση, αναζήτηση και κοστολόγηση πόρων στην AWS.
  tags = {
    Name        = "${var.project_name}-${var.environment}-internal-alb-sg"
    Environment = var.environment
  }
}

# App tier Security Group (accepts traffic from internal ALB)

# Δημιουργεί Security Group. Terraform όνομα: app.
resource "aws_security_group" "app" {
  # Ορίζει το όνομα του πόρου μέσα στην AWS.
  name        = "${var.project_name}-${var.environment}-app-sg"
  # Περιγράφει τον σκοπό του πόρου.
  description = "Allow app traffic from internal ALB"
  # Συνδέει τον πόρο με το συγκεκριμένο VPC.
  vpc_id      = aws_vpc.main.id

  # Κανόνας εισερχόμενης κίνησης στο Security Group.
  ingress {
    # Περιγράφει τον σκοπό του πόρου.
    description     = "App traffic from internal ALB"
    # Ορίζει την αρχική πόρτα του κανόνα.
    from_port       = var.app_port
    # Ορίζει την τελική πόρτα του κανόνα.
    to_port         = var.app_port
    # Ορίζει το πρωτόκολλο δικτύου, π.χ. tcp ή HTTP.
    protocol        = "tcp"
    # Επιτρέπει κίνηση μόνο από τα συγκεκριμένα Security Groups.
    security_groups = [aws_security_group.internal_alb.id]
  }

  # Κανόνας εξερχόμενης κίνησης από το Security Group.
  egress {
    # Περιγράφει τον σκοπό του πόρου.
    description = "Allow outbound from app tier"
    # Ορίζει την αρχική πόρτα του κανόνα.
    from_port   = 0
    # Ορίζει την τελική πόρτα του κανόνα.
    to_port     = 0
    # Ορίζει το πρωτόκολλο δικτύου, π.χ. tcp ή HTTP.
    protocol    = "-1"
    # Ορίζει από ποια IP ranges επιτρέπεται η κίνηση.
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Tags για οργάνωση, αναζήτηση και κοστολόγηση πόρων στην AWS.
  tags = {
    Name        = "${var.project_name}-${var.environment}-app-sg"
    Environment = var.environment
  }
}

# RDS Security Group (accepts traffic from app tier)

# Δημιουργεί Security Group. Terraform όνομα: rds.
resource "aws_security_group" "rds" {
  # Ορίζει το όνομα του πόρου μέσα στην AWS.
  name        = "${var.project_name}-${var.environment}-rds-sg"
  # Περιγράφει τον σκοπό του πόρου.
  description = "Allow MySQL only from app tier"
  # Συνδέει τον πόρο με το συγκεκριμένο VPC.
  vpc_id      = aws_vpc.main.id

  # Κανόνας εισερχόμενης κίνησης στο Security Group.
  ingress {
    # Περιγράφει τον σκοπό του πόρου.
    description     = "MySQL from app tier"
    # Ορίζει την αρχική πόρτα του κανόνα.
    from_port       = 3306
    # Ορίζει την τελική πόρτα του κανόνα.
    to_port         = 3306
    # Ορίζει το πρωτόκολλο δικτύου, π.χ. tcp ή HTTP.
    protocol        = "tcp"
    # Επιτρέπει κίνηση μόνο από τα συγκεκριμένα Security Groups.
    security_groups = [aws_security_group.app.id]
  }

  # Κανόνας εξερχόμενης κίνησης από το Security Group.
  egress {
    # Περιγράφει τον σκοπό του πόρου.
    description = "Allow outbound from RDS"
    # Ορίζει την αρχική πόρτα του κανόνα.
    from_port   = 0
    # Ορίζει την τελική πόρτα του κανόνα.
    to_port     = 0
    # Ορίζει το πρωτόκολλο δικτύου, π.χ. tcp ή HTTP.
    protocol    = "-1"
    # Ορίζει από ποια IP ranges επιτρέπεται η κίνηση.
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Tags για οργάνωση, αναζήτηση και κοστολόγηση πόρων στην AWS.
  tags = {
    Name        = "${var.project_name}-${var.environment}-rds-sg"
    Environment = var.environment
  }
}
