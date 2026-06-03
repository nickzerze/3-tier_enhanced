output "vpc_id" {
  description = "Main VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = local.public_subnet_ids
}

output "private_web_subnet_ids" {
  description = "Private web subnet IDs"
  value       = local.private_web_subnet_ids
}

output "private_app_subnet_ids" {
  description = "Private app subnet IDs"
  value       = local.private_app_subnet_ids
}

output "private_db_subnet_ids" {
  description = "Private database subnet IDs"
  value       = local.private_db_subnet_ids
}

output "public_alb_security_group_id" {
  description = "Public ALB security group ID"
  value       = aws_security_group.public_alb.id
}

output "web_security_group_id" {
  description = "Web tier security group ID"
  value       = aws_security_group.web.id
}

output "internal_alb_security_group_id" {
  description = "Internal ALB security group ID"
  value       = aws_security_group.internal_alb.id
}

output "app_security_group_id" {
  description = "App tier security group ID"
  value       = aws_security_group.app.id
}

output "rds_security_group_id" {
  description = "RDS security group ID"
  value       = aws_security_group.rds.id
}

output "web_target_group_arn" {
  description = "Web target group ARN"
  value       = aws_lb_target_group.web.arn
}

output "app_target_group_arn" {
  description = "App target group ARN"
  value       = aws_lb_target_group.app.arn
}

output "route53_name_servers" {
  description = "Name servers to configure in Namecheap"
  value       = aws_route53_zone.main.name_servers
}

output "application_url" {
  description = "Application HTTPS URL"
  value       = "https://${var.domain_name}"
}

output "public_alb_dns_name" {
  description = "Public ALB DNS name"
  value       = aws_lb.public_web.dns_name
}

output "public_alb_arn" {
  description = "Public ALB ARN"
  value       = aws_lb.public_web.arn
}

output "acm_certificate_arn" {
  description = "ACM certificate ARN"
  value       = aws_acm_certificate.public_alb.arn
}

output "rds_endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.main.endpoint
}

output "rds_address" {
  description = "RDS address"
  value       = aws_db_instance.main.address
}

output "rds_database_name" {
  description = "RDS database name"
  value       = aws_db_instance.main.db_name
}

output "db_secret_arn" {
  description = "Secrets Manager secret ARN for database credentials"
  value       = aws_secretsmanager_secret.db_credentials.arn
}

output "internal_alb_dns_name" {
  description = "Internal ALB DNS name"
  value       = aws_lb.internal_app.dns_name
}

output "internal_alb_arn" {
  description = "Internal ALB ARN"
  value       = aws_lb.internal_app.arn
}

output "artifacts_bucket_name" {
  description = "S3 bucket for deployment artifacts"
  value       = aws_s3_bucket.artifacts.bucket
}

output "ec2_instance_profile_name" {
  description = "EC2 IAM instance profile name"
  value       = aws_iam_instance_profile.ec2.name
}

output "app_launch_template_id" {
  description = "App tier launch template ID"
  value       = aws_launch_template.app.id
}

output "web_launch_template_id" {
  description = "Web tier launch template ID"
  value       = aws_launch_template.web.id
}

output "app_asg_name" {
  description = "App Auto Scaling Group name"
  value       = aws_autoscaling_group.app.name
}

output "web_asg_name" {
  description = "Web Auto Scaling Group name"
  value       = aws_autoscaling_group.web.name
}

output "waf_web_acl_arn" {
  description = "WAF Web ACL ARN"
  value       = var.enable_waf ? aws_wafv2_web_acl.public_alb[0].arn : null
}

output "waf_web_acl_name" {
  description = "WAF Web ACL name"
  value       = var.enable_waf ? aws_wafv2_web_acl.public_alb[0].name : null
}