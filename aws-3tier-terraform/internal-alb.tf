# Internal Application Load Balancer
resource "aws_lb" "internal_app" {
  name               = "${var.project_name}-${var.environment}-internal-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.internal_alb.id]
  subnets            = local.private_app_subnet_ids

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-internal-alb"
  })
}

# Target group for internal ALB
resource "aws_lb_listener" "internal_http" {
  load_balancer_arn = aws_lb.internal_app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}