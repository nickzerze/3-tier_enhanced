# Αρχείο για τον δημόσιο Application Load Balancer, τους listeners HTTP/HTTPS και το DNS alias record.

# ALB Resource

# Δημιουργεί Application Load Balancer. Terraform όνομα: public_web.
resource "aws_lb" "public_web" {
  # Ορίζει το όνομα του πόρου μέσα στην AWS.
  name               = "${var.project_name}-${var.environment}-public-alb"
  # Καθορίζει αν ο Load Balancer είναι εσωτερικός ή δημόσιος.
  internal           = false
  # Ορίζει τον τύπο Load Balancer.
  load_balancer_type = "application"
  # Επιτρέπει κίνηση μόνο από τα συγκεκριμένα Security Groups.
  security_groups    = [aws_security_group.public_alb.id]

  # subnets = [
  #   aws_subnet.public_az1.id,
  #   aws_subnet.public_az2.id
  # ]
  subnets = local.public_subnet_ids

  # Tags για οργάνωση, αναζήτηση και κοστολόγηση πόρων στην AWS.
  tags = {
    Name        = "${var.project_name}-${var.environment}-public-alb"
    Environment = var.environment
  }
}

# Listener for public ALB (HTTP to HTTPS redirect) 

# Δημιουργεί listener που δέχεται traffic στον Load Balancer. Terraform όνομα: public_http.
resource "aws_lb_listener" "public_http" {
  # Συνδέει τον listener με συγκεκριμένο Load Balancer.
  load_balancer_arn = aws_lb.public_web.arn
  # Ορίζει την πόρτα στην οποία ακούει ο πόρος.
  port              = 80
  # Ορίζει το πρωτόκολλο δικτύου, π.χ. tcp ή HTTP.
  protocol          = "HTTP"

  # Προεπιλεγμένη ενέργεια όταν δεν ταιριάζει κάποιος ειδικός κανόνας.
  default_action {
    # Ορίζει τον τύπο της τιμής ή της ενέργειας, ανάλογα με το block.
    type = "redirect"

    # Ρυθμίσεις redirect, εδώ από HTTP προς HTTPS.
    redirect {
      # Ορίζει την πόρτα στην οποία ακούει ο πόρος.
      port        = "443"
      # Ορίζει το πρωτόκολλο δικτύου, π.χ. tcp ή HTTP.
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# Listener for public ALB (HTTPS to web target group) 

# Δημιουργεί listener που δέχεται traffic στον Load Balancer. Terraform όνομα: public_https.
resource "aws_lb_listener" "public_https" {
  # Συνδέει τον listener με συγκεκριμένο Load Balancer.
  load_balancer_arn = aws_lb.public_web.arn
  # Ορίζει την πόρτα στην οποία ακούει ο πόρος.
  port              = 443
  # Ορίζει το πρωτόκολλο δικτύου, π.χ. tcp ή HTTP.
  protocol          = "HTTPS"

  # Αναφέρεται στο ARN του πιστοποιητικού.
  certificate_arn = aws_acm_certificate_validation.public_alb.certificate_arn
  # Ορίζει την TLS policy που χρησιμοποιεί το HTTPS listener.
  ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-2021-06"

  # Προεπιλεγμένη ενέργεια όταν δεν ταιριάζει κάποιος ειδικός κανόνας.
  default_action {
    # Ορίζει τον τύπο της τιμής ή της ενέργειας, ανάλογα με το block.
    type             = "forward"
    # Στέλνει την κίνηση στο συγκεκριμένο Target Group.
    target_group_arn = aws_lb_target_group.web.arn
  }
}

# Route53 record for public ALB

# Δημιουργεί DNS record στο Route 53. Terraform όνομα: app.
resource "aws_route53_record" "app" {
  # Ορίζει τη Route 53 hosted zone όπου δημιουργείται DNS record.
  zone_id = aws_route53_zone.main.zone_id
  # Ορίζει το όνομα του πόρου μέσα στην AWS.
  name    = var.domain_name
  # Ορίζει τον τύπο της τιμής ή της ενέργειας, ανάλογα με το block.
  type    = "A"

  # Alias DNS record που δείχνει απευθείας σε AWS Load Balancer.
  alias {
    # Ορίζει το όνομα του πόρου μέσα στην AWS.
    name                   = aws_lb.public_web.dns_name
    # Ορίζει τη Route 53 hosted zone όπου δημιουργείται DNS record.
    zone_id                = aws_lb.public_web.zone_id
    evaluate_target_health = true
  }
}
