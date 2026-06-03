# Αρχείο για τα Target Groups των Load Balancers και τα health checks τους.

# Target Group for Web Tier 

# Δημιουργεί Target Group για ALB. Terraform όνομα: web.
resource "aws_lb_target_group" "web" {
  # Ορίζει το όνομα του πόρου μέσα στην AWS.
  name        = "${var.project_name}-${var.environment}-web-tg"
  # Ορίζει την πόρτα στην οποία ακούει ο πόρος.
  port        = var.web_port
  # Ορίζει το πρωτόκολλο δικτύου, π.χ. tcp ή HTTP.
  protocol    = "HTTP"
  # Συνδέει τον πόρο με το συγκεκριμένο VPC.
  vpc_id      = aws_vpc.main.id
  target_type = "instance"

  # Ρυθμίσεις health check για να κρίνει το ALB αν οι targets είναι healthy.
  health_check {
    # Ενεργοποιεί τη συγκεκριμένη λειτουργία.
    enabled             = true
    # Ορίζει το URL path για health check ή αρχείο template.
    path                = var.web_health_check_path
    # Ορίζει το πρωτόκολλο δικτύου, π.χ. tcp ή HTTP.
    protocol            = "HTTP"
    # Ορίζει ποιο HTTP status range θεωρείται επιτυχία.
    matcher             = "200-399"
    # Ορίζει κάθε πόσα δευτερόλεπτα γίνεται health check.
    interval            = 30
    # Ορίζει πόσο περιμένει το health check πριν αποτύχει.
    timeout             = 5
    # Ορίζει πόσες επιτυχίες χρειάζονται για healthy κατάσταση.
    healthy_threshold   = 2
    # Ορίζει πόσες αποτυχίες χρειάζονται για unhealthy κατάσταση.
    unhealthy_threshold = 3
  }

  # Tags για οργάνωση, αναζήτηση και κοστολόγηση πόρων στην AWS.
  tags = {
    Name        = "${var.project_name}-${var.environment}-web-tg"
    Environment = var.environment
  }
}

# Target Group for App Tier

# Δημιουργεί Target Group για ALB. Terraform όνομα: app.
resource "aws_lb_target_group" "app" {
  # Ορίζει το όνομα του πόρου μέσα στην AWS.
  name        = "${var.project_name}-${var.environment}-app-tg"
  # Ορίζει την πόρτα στην οποία ακούει ο πόρος.
  port        = var.app_port
  # Ορίζει το πρωτόκολλο δικτύου, π.χ. tcp ή HTTP.
  protocol    = "HTTP"
  # Συνδέει τον πόρο με το συγκεκριμένο VPC.
  vpc_id      = aws_vpc.main.id
  target_type = "instance"

  # Ρυθμίσεις health check για να κρίνει το ALB αν οι targets είναι healthy.
  health_check {
    # Ενεργοποιεί τη συγκεκριμένη λειτουργία.
    enabled             = true
    # Ορίζει το URL path για health check ή αρχείο template.
    path                = var.app_health_check_path
    # Ορίζει το πρωτόκολλο δικτύου, π.χ. tcp ή HTTP.
    protocol            = "HTTP"
    # Ορίζει ποιο HTTP status range θεωρείται επιτυχία.
    matcher             = "200-399"
    # Ορίζει κάθε πόσα δευτερόλεπτα γίνεται health check.
    interval            = 30
    # Ορίζει πόσο περιμένει το health check πριν αποτύχει.
    timeout             = 5
    # Ορίζει πόσες επιτυχίες χρειάζονται για healthy κατάσταση.
    healthy_threshold   = 2
    # Ορίζει πόσες αποτυχίες χρειάζονται για unhealthy κατάσταση.
    unhealthy_threshold = 3
  }

  # Tags για οργάνωση, αναζήτηση και κοστολόγηση πόρων στην AWS.
  tags = {
    Name        = "${var.project_name}-${var.environment}-app-tg"
    Environment = var.environment
  }
}


