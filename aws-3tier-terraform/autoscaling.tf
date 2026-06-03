# Auto Scaling Group for Application Tier
resource "aws_autoscaling_group" "app" {
  name = "${var.project_name}-${var.environment}-app-asg"

  vpc_zone_identifier = local.private_app_subnet_ids

  desired_capacity = var.app_desired_capacity
  min_size         = var.app_min_size
  max_size         = var.app_max_size

  health_check_type         = "ELB"
  health_check_grace_period = 300

  target_group_arns = [
    aws_lb_target_group.app.arn
  ]

  launch_template {
    id      = aws_launch_template.app.id
    version = aws_launch_template.app.latest_version
  }

  instance_refresh {
    strategy = "Rolling"

    preferences {
      min_healthy_percentage = 50
    }
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.environment}-app"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }

  tag {
    key                 = "Tier"
    value               = "app"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Launch Template for Web Tier
resource "aws_autoscaling_group" "web" {
  name = "${var.project_name}-${var.environment}-web-asg"

  vpc_zone_identifier = local.private_web_subnet_ids

  desired_capacity = var.web_desired_capacity
  min_size         = var.web_min_size
  max_size         = var.web_max_size

  health_check_type         = "ELB"
  health_check_grace_period = 300

  target_group_arns = [
    aws_lb_target_group.web.arn
  ]

  launch_template {
    id      = aws_launch_template.web.id
    version = aws_launch_template.web.latest_version
  }

  instance_refresh {
    strategy = "Rolling"

    preferences {
      min_healthy_percentage = 50
    }
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.environment}-web"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }

  tag {
    key                 = "Tier"
    value               = "web"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

