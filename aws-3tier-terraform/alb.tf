# ALB Resource
resource "aws_lb" "public_web" {
  name               = "${var.project_name}-${var.environment}-public-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public_alb.id]

  # subnets = [
  #   aws_subnet.public_az1.id,
  #   aws_subnet.public_az2.id
  # ]
  subnets = local.public_subnet_ids

  tags = {
    Name        = "${var.project_name}-${var.environment}-public-alb"
    Environment = var.environment
  }
}

# Listener for public ALB (HTTP to HTTPS redirect) 
resource "aws_lb_listener" "public_http" {
  load_balancer_arn = aws_lb.public_web.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# Listener for public ALB (HTTPS to web target group) 
resource "aws_lb_listener" "public_https" {
  load_balancer_arn = aws_lb.public_web.arn
  port              = 443
  protocol          = "HTTPS"

  certificate_arn = aws_acm_certificate_validation.public_alb.certificate_arn
  ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-2021-06"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

# Route53 record for public ALB
resource "aws_route53_record" "app" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.public_web.dns_name
    zone_id                = aws_lb.public_web.zone_id
    evaluate_target_health = true
  }
}