data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name = "name"
    values = [
      "al2023-ami-*-x86_64"
    ]
  }

  filter {
    name = "architecture"
    values = [
      "x86_64"
    ]
  }

  filter {
    name = "virtualization-type"
    values = [
      "hvm"
    ]
  }
}

# Launch Template for App Tier
resource "aws_launch_template" "app" {
  name_prefix   = "${var.project_name}-${var.environment}-app-"
  image_id      = data.aws_ami.amazon_linux_2023.id
  instance_type = var.ec2_instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2.name
  }

  vpc_security_group_ids = [
    aws_security_group.app.id
  ]

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

user_data = base64encode(templatefile("${path.module}/entry-script_app.sh.tpl", {
  aws_region          = var.aws_region
  artifacts_bucket    = aws_s3_bucket.artifacts.bucket
  app_artifact_s3_key = var.app_artifact_s3_key
  db_secret_arn       = aws_secretsmanager_secret.db_credentials.arn
  db_host             = aws_db_instance.main.address
}))
    
  tag_specifications {
    resource_type = "instance"

    tags = merge(local.common_tags, {
      Name = "${var.project_name}-${var.environment}-app"
      Tier = "app"
    })
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-app-launch-template"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Launch Template for Web Tier (similar to App, but with different user data and tags)
resource "aws_launch_template" "web" {
  name_prefix   = "${var.project_name}-${var.environment}-web-"
  image_id      = data.aws_ami.amazon_linux_2023.id
  instance_type = var.ec2_instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2.name
  }

  vpc_security_group_ids = [
    aws_security_group.web.id
  ]

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

user_data = base64encode(templatefile("${path.module}/entry-script_web.sh.tpl", {
  artifacts_bucket     = aws_s3_bucket.artifacts.bucket
  web_artifact_s3_key  = var.web_artifact_s3_key
  internal_alb_dns_name = aws_lb.internal_app.dns_name
}))

  tag_specifications {
    resource_type = "instance"

    tags = merge(local.common_tags, {
      Name = "${var.project_name}-${var.environment}-web"
      Tier = "web"
    })
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-web-launch-template"
  })

  lifecycle {
    create_before_destroy = true
  }
}