# Αρχείο με outputs, δηλαδή τιμές που εμφανίζονται μετά το terraform apply για εύκολη αναφορά.

# Ορίζει output `vpc_id` για να εμφανίζεται χρήσιμη πληροφορία μετά το apply.
output "vpc_id" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "Main VPC ID"
  # Ορίζει την τιμή ενός output ή tag.
  value       = aws_vpc.main.id
}

# Ορίζει output `public_subnet_ids` για να εμφανίζεται χρήσιμη πληροφορία μετά το apply.
output "public_subnet_ids" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "Public subnet IDs"
  # Ορίζει την τιμή ενός output ή tag.
  value       = local.public_subnet_ids
}

# Ορίζει output `private_web_subnet_ids` για να εμφανίζεται χρήσιμη πληροφορία μετά το apply.
output "private_web_subnet_ids" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "Private web subnet IDs"
  # Ορίζει την τιμή ενός output ή tag.
  value       = local.private_web_subnet_ids
}

# Ορίζει output `private_app_subnet_ids` για να εμφανίζεται χρήσιμη πληροφορία μετά το apply.
output "private_app_subnet_ids" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "Private app subnet IDs"
  # Ορίζει την τιμή ενός output ή tag.
  value       = local.private_app_subnet_ids
}

# Ορίζει output `private_db_subnet_ids` για να εμφανίζεται χρήσιμη πληροφορία μετά το apply.
output "private_db_subnet_ids" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "Private database subnet IDs"
  # Ορίζει την τιμή ενός output ή tag.
  value       = local.private_db_subnet_ids
}

# Ορίζει output `public_alb_security_group_id` για να εμφανίζεται χρήσιμη πληροφορία μετά το apply.
output "public_alb_security_group_id" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "Public ALB security group ID"
  # Ορίζει την τιμή ενός output ή tag.
  value       = aws_security_group.public_alb.id
}

# Ορίζει output `web_security_group_id` για να εμφανίζεται χρήσιμη πληροφορία μετά το apply.
output "web_security_group_id" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "Web tier security group ID"
  # Ορίζει την τιμή ενός output ή tag.
  value       = aws_security_group.web.id
}

# Ορίζει output `internal_alb_security_group_id` για να εμφανίζεται χρήσιμη πληροφορία μετά το apply.
output "internal_alb_security_group_id" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "Internal ALB security group ID"
  # Ορίζει την τιμή ενός output ή tag.
  value       = aws_security_group.internal_alb.id
}

# Ορίζει output `app_security_group_id` για να εμφανίζεται χρήσιμη πληροφορία μετά το apply.
output "app_security_group_id" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "App tier security group ID"
  # Ορίζει την τιμή ενός output ή tag.
  value       = aws_security_group.app.id
}

# Ορίζει output `rds_security_group_id` για να εμφανίζεται χρήσιμη πληροφορία μετά το apply.
output "rds_security_group_id" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "RDS security group ID"
  # Ορίζει την τιμή ενός output ή tag.
  value       = aws_security_group.rds.id
}

# Ορίζει output `web_target_group_arn` για να εμφανίζεται χρήσιμη πληροφορία μετά το apply.
output "web_target_group_arn" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "Web target group ARN"
  # Ορίζει την τιμή ενός output ή tag.
  value       = aws_lb_target_group.web.arn
}

# Ορίζει output `app_target_group_arn` για να εμφανίζεται χρήσιμη πληροφορία μετά το apply.
output "app_target_group_arn" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "App target group ARN"
  # Ορίζει την τιμή ενός output ή tag.
  value       = aws_lb_target_group.app.arn
}

# Ορίζει output `route53_name_servers` για να εμφανίζεται χρήσιμη πληροφορία μετά το apply.
output "route53_name_servers" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "Name servers to configure in Namecheap"
  # Ορίζει την τιμή ενός output ή tag.
  value       = aws_route53_zone.main.name_servers
}

# Ορίζει output `application_url` για να εμφανίζεται χρήσιμη πληροφορία μετά το apply.
output "application_url" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "Application HTTPS URL"
  # Ορίζει την τιμή ενός output ή tag.
  value       = "https://${var.domain_name}"
}

# Ορίζει output `public_alb_dns_name` για να εμφανίζεται χρήσιμη πληροφορία μετά το apply.
output "public_alb_dns_name" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "Public ALB DNS name"
  # Ορίζει την τιμή ενός output ή tag.
  value       = aws_lb.public_web.dns_name
}

# Ορίζει output `public_alb_arn` για να εμφανίζεται χρήσιμη πληροφορία μετά το apply.
output "public_alb_arn" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "Public ALB ARN"
  # Ορίζει την τιμή ενός output ή tag.
  value       = aws_lb.public_web.arn
}

# Ορίζει output `acm_certificate_arn` για να εμφανίζεται χρήσιμη πληροφορία μετά το apply.
output "acm_certificate_arn" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "ACM certificate ARN"
  # Ορίζει την τιμή ενός output ή tag.
  value       = aws_acm_certificate.public_alb.arn
}

# Ορίζει output `rds_endpoint` για να εμφανίζεται χρήσιμη πληροφορία μετά το apply.
output "rds_endpoint" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "RDS endpoint"
  # Ορίζει την τιμή ενός output ή tag.
  value       = aws_db_instance.main.endpoint
}

# Ορίζει output `rds_address` για να εμφανίζεται χρήσιμη πληροφορία μετά το apply.
output "rds_address" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "RDS address"
  # Ορίζει την τιμή ενός output ή tag.
  value       = aws_db_instance.main.address
}

# Ορίζει output `rds_database_name` για να εμφανίζεται χρήσιμη πληροφορία μετά το apply.
output "rds_database_name" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "RDS database name"
  # Ορίζει την τιμή ενός output ή tag.
  value       = aws_db_instance.main.db_name
}

# Ορίζει output `db_secret_arn` για να εμφανίζεται χρήσιμη πληροφορία μετά το apply.
output "db_secret_arn" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "Secrets Manager secret ARN for database credentials"
  # Ορίζει την τιμή ενός output ή tag.
  value       = aws_secretsmanager_secret.db_credentials.arn
}

# Ορίζει output `internal_alb_dns_name` για να εμφανίζεται χρήσιμη πληροφορία μετά το apply.
output "internal_alb_dns_name" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "Internal ALB DNS name"
  # Ορίζει την τιμή ενός output ή tag.
  value       = aws_lb.internal_app.dns_name
}

# Ορίζει output `internal_alb_arn` για να εμφανίζεται χρήσιμη πληροφορία μετά το apply.
output "internal_alb_arn" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "Internal ALB ARN"
  # Ορίζει την τιμή ενός output ή tag.
  value       = aws_lb.internal_app.arn
}

# Ορίζει output `artifacts_bucket_name` για να εμφανίζεται χρήσιμη πληροφορία μετά το apply.
output "artifacts_bucket_name" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "S3 bucket for deployment artifacts"
  # Ορίζει την τιμή ενός output ή tag.
  value       = aws_s3_bucket.artifacts.bucket
}

# Ορίζει output `ec2_instance_profile_name` για να εμφανίζεται χρήσιμη πληροφορία μετά το apply.
output "ec2_instance_profile_name" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "EC2 IAM instance profile name"
  # Ορίζει την τιμή ενός output ή tag.
  value       = aws_iam_instance_profile.ec2.name
}

# Ορίζει output `app_launch_template_id` για να εμφανίζεται χρήσιμη πληροφορία μετά το apply.
output "app_launch_template_id" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "App tier launch template ID"
  # Ορίζει την τιμή ενός output ή tag.
  value       = aws_launch_template.app.id
}

# Ορίζει output `web_launch_template_id` για να εμφανίζεται χρήσιμη πληροφορία μετά το apply.
output "web_launch_template_id" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "Web tier launch template ID"
  # Ορίζει την τιμή ενός output ή tag.
  value       = aws_launch_template.web.id
}

# Ορίζει output `app_asg_name` για να εμφανίζεται χρήσιμη πληροφορία μετά το apply.
output "app_asg_name" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "App Auto Scaling Group name"
  # Ορίζει την τιμή ενός output ή tag.
  value       = aws_autoscaling_group.app.name
}

# Ορίζει output `web_asg_name` για να εμφανίζεται χρήσιμη πληροφορία μετά το apply.
output "web_asg_name" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "Web Auto Scaling Group name"
  # Ορίζει την τιμή ενός output ή tag.
  value       = aws_autoscaling_group.web.name
}

# Ορίζει output `waf_web_acl_arn` για να εμφανίζεται χρήσιμη πληροφορία μετά το apply.
output "waf_web_acl_arn" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "WAF Web ACL ARN"
  # Ορίζει την τιμή ενός output ή tag.
  value       = var.enable_waf ? aws_wafv2_web_acl.public_alb[0].arn : null
}

# Ορίζει output `waf_web_acl_name` για να εμφανίζεται χρήσιμη πληροφορία μετά το apply.
output "waf_web_acl_name" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "WAF Web ACL name"
  # Ορίζει την τιμή ενός output ή tag.
  value       = var.enable_waf ? aws_wafv2_web_acl.public_alb[0].name : null
}
