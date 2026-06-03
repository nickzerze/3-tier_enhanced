# Αρχείο για τα Auto Scaling Groups του app tier και του web tier.

# Auto Scaling Group for Application Tier

# Δημιουργεί Auto Scaling Group για αυτόματη διαχείριση EC2 instances. Terraform όνομα: app.
resource "aws_autoscaling_group" "app" {
  # Ορίζει το όνομα του πόρου μέσα στην AWS.
  name = "${var.project_name}-${var.environment}-app-asg"

  vpc_zone_identifier = local.private_app_subnet_ids

  # Ορίζει πόσα instances θέλουμε κανονικά να τρέχουν.
  desired_capacity = var.app_desired_capacity
  # Ορίζει το ελάχιστο πλήθος instances.
  min_size         = var.app_min_size
  # Ορίζει το μέγιστο πλήθος instances.
  max_size         = var.app_max_size

  # Ορίζει αν τα health checks γίνονται από EC2 ή ELB.
  health_check_type         = "ELB"
  # Δίνει χρόνο στο instance να ξεκινήσει πριν αποτύχουν health checks.
  health_check_grace_period = 300

  # Συνδέει το Auto Scaling Group με Target Groups για load balancing και health checks.
  target_group_arns = [
    aws_lb_target_group.app.arn
  ]

  # Σύνδεση του Auto Scaling Group με το Launch Template.
  launch_template {
    # Αναφέρεται στο ID άλλου Terraform/AWS πόρου.
    id      = aws_launch_template.app.id
    # Ορίζει έκδοση αντικειμένου, policy ή provider.
    version = aws_launch_template.app.latest_version
  }

  # Ρυθμίσεις rolling refresh όταν αλλάζει το launch template.
  instance_refresh {
    # Ορίζει τη στρατηγική ενημέρωσης/refresh.
    strategy = "Rolling"

    # Προτιμήσεις για το rolling instance refresh.
    preferences {
      # Ορίζει το ελάχιστο ποσοστό υγιών instances κατά το rolling refresh.
      min_healthy_percentage = 50
    }
  }

  tag {
    # Ορίζει το όνομα ενός tag.
    key                 = "Name"
    # Ορίζει την τιμή ενός output ή tag.
    value               = "${var.project_name}-${var.environment}-app"
    # Περνά το tag αυτόματα στα EC2 instances που δημιουργούνται.
    propagate_at_launch = true
  }

  tag {
    # Ορίζει το όνομα ενός tag.
    key                 = "Environment"
    # Ορίζει την τιμή ενός output ή tag.
    value               = var.environment
    # Περνά το tag αυτόματα στα EC2 instances που δημιουργούνται.
    propagate_at_launch = true
  }

  tag {
    # Ορίζει το όνομα ενός tag.
    key                 = "Tier"
    # Ορίζει την τιμή ενός output ή tag.
    value               = "app"
    # Περνά το tag αυτόματα στα EC2 instances που δημιουργούνται.
    propagate_at_launch = true
  }

  # Lifecycle κανόνες που αλλάζουν τη συμπεριφορά δημιουργίας/διαγραφής.
  lifecycle {
    # Δημιουργεί νέο πόρο πριν καταστρέψει τον παλιό για αποφυγή downtime.
    create_before_destroy = true
  }
}

# Launch Template for Web Tier

# Δημιουργεί Auto Scaling Group για αυτόματη διαχείριση EC2 instances. Terraform όνομα: web.
resource "aws_autoscaling_group" "web" {
  # Ορίζει το όνομα του πόρου μέσα στην AWS.
  name = "${var.project_name}-${var.environment}-web-asg"

  vpc_zone_identifier = local.private_web_subnet_ids

  # Ορίζει πόσα instances θέλουμε κανονικά να τρέχουν.
  desired_capacity = var.web_desired_capacity
  # Ορίζει το ελάχιστο πλήθος instances.
  min_size         = var.web_min_size
  # Ορίζει το μέγιστο πλήθος instances.
  max_size         = var.web_max_size

  # Ορίζει αν τα health checks γίνονται από EC2 ή ELB.
  health_check_type         = "ELB"
  # Δίνει χρόνο στο instance να ξεκινήσει πριν αποτύχουν health checks.
  health_check_grace_period = 300

  # Συνδέει το Auto Scaling Group με Target Groups για load balancing και health checks.
  target_group_arns = [
    aws_lb_target_group.web.arn
  ]

  # Σύνδεση του Auto Scaling Group με το Launch Template.
  launch_template {
    # Αναφέρεται στο ID άλλου Terraform/AWS πόρου.
    id      = aws_launch_template.web.id
    # Ορίζει έκδοση αντικειμένου, policy ή provider.
    version = aws_launch_template.web.latest_version
  }

  # Ρυθμίσεις rolling refresh όταν αλλάζει το launch template.
  instance_refresh {
    # Ορίζει τη στρατηγική ενημέρωσης/refresh.
    strategy = "Rolling"

    # Προτιμήσεις για το rolling instance refresh.
    preferences {
      # Ορίζει το ελάχιστο ποσοστό υγιών instances κατά το rolling refresh.
      min_healthy_percentage = 50
    }
  }

  tag {
    # Ορίζει το όνομα ενός tag.
    key                 = "Name"
    # Ορίζει την τιμή ενός output ή tag.
    value               = "${var.project_name}-${var.environment}-web"
    # Περνά το tag αυτόματα στα EC2 instances που δημιουργούνται.
    propagate_at_launch = true
  }

  tag {
    # Ορίζει το όνομα ενός tag.
    key                 = "Environment"
    # Ορίζει την τιμή ενός output ή tag.
    value               = var.environment
    # Περνά το tag αυτόματα στα EC2 instances που δημιουργούνται.
    propagate_at_launch = true
  }

  tag {
    # Ορίζει το όνομα ενός tag.
    key                 = "Tier"
    # Ορίζει την τιμή ενός output ή tag.
    value               = "web"
    # Περνά το tag αυτόματα στα EC2 instances που δημιουργούνται.
    propagate_at_launch = true
  }

  # Lifecycle κανόνες που αλλάζουν τη συμπεριφορά δημιουργίας/διαγραφής.
  lifecycle {
    # Δημιουργεί νέο πόρο πριν καταστρέψει τον παλιό για αποφυγή downtime.
    create_before_destroy = true
  }
}

