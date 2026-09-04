# Αρχείο για τον εσωτερικό Application Load Balancer που συνδέει web tier με app tier.

# Internal Application Load Balancer

# Δημιουργεί Application Load Balancer. Terraform όνομα: internal_app.
resource "aws_lb" "internal_app" {
  # Ορίζει το όνομα του πόρου μέσα στην AWS.
  name = "${var.project_name}-${var.environment}-internal-alb"
  # Καθορίζει αν ο Load Balancer είναι εσωτερικός ή δημόσιος.
  internal = true
  # Ορίζει τον τύπο Load Balancer.
  load_balancer_type = "application"
  # Επιτρέπει κίνηση μόνο από τα συγκεκριμένα Security Groups.
  security_groups = [aws_security_group.internal_alb.id]
  subnets         = local.private_app_subnet_ids

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-internal-alb"
  })
}

# Target group for internal ALB

# Δημιουργεί listener που δέχεται traffic στον Load Balancer. Terraform όνομα: internal_http.
resource "aws_lb_listener" "internal_http" {
  # Συνδέει τον listener με συγκεκριμένο Load Balancer.
  load_balancer_arn = aws_lb.internal_app.arn
  # Ορίζει την πόρτα στην οποία ακούει ο πόρος.
  port = 80
  # Ορίζει το πρωτόκολλο δικτύου, π.χ. tcp ή HTTP.
  protocol = "HTTP"

  # Προεπιλεγμένη ενέργεια όταν δεν ταιριάζει κάποιος ειδικός κανόνας.
  default_action {
    # Ορίζει τον τύπο της τιμής ή της ενέργειας, ανάλογα με το block.
    type = "forward"
    # Στέλνει την κίνηση στο συγκεκριμένο Target Group.
    target_group_arn = aws_lb_target_group.app.arn
  }
}
