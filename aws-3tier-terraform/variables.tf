variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "aws-3tier"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "domain_name" {
  description = "Application domain name"
  type        = string
}

variable "route53_zone_name" {
  description = "Root domain hosted in Route 53"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Database master username"
  type        = string
  default     = "adminuser"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t4g.micro"
}

variable "db_allocated_storage" {
  description = "Allocated storage for RDS in GB"
  type        = number
  default     = 20
}

variable "db_max_allocated_storage" {
  description = "Maximum autoscaled storage for RDS in GB"
  type        = number
  default     = 100
}

variable "db_backup_retention_period" {
  description = "Number of days to retain automated backups"
  type        = number
  default     = 7
}

variable "enable_rds_multi_az" {
  description = "Enable Multi-AZ deployment for RDS"
  type        = bool
  default     = true
}

variable "vpc_cidr" {
  description = "CIDR block for the main VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_az1_cidr" {
  description = "CIDR block for public subnet in AZ1"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_az2_cidr" {
  description = "CIDR block for public subnet in AZ2"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_web_subnet_az1_cidr" {
  description = "CIDR block for private web subnet in AZ1"
  type        = string
  default     = "10.0.11.0/24"
}

variable "private_web_subnet_az2_cidr" {
  description = "CIDR block for private web subnet in AZ2"
  type        = string
  default     = "10.0.12.0/24"
}

variable "private_app_subnet_az1_cidr" {
  description = "CIDR block for private app subnet in AZ1"
  type        = string
  default     = "10.0.21.0/24"
}

variable "private_app_subnet_az2_cidr" {
  description = "CIDR block for private app subnet in AZ2"
  type        = string
  default     = "10.0.22.0/24"
}

variable "private_db_subnet_az1_cidr" {
  description = "CIDR block for private database subnet in AZ1"
  type        = string
  default     = "10.0.31.0/24"
}

variable "private_db_subnet_az2_cidr" {
  description = "CIDR block for private database subnet in AZ2"
  type        = string
  default     = "10.0.32.0/24"
}

variable "web_health_check_path" {
  description = "Health check path for web target group"
  type        = string
  default     = "/"
}

variable "app_health_check_path" {
  description = "Health check path for app target group"
  type        = string
  default     = "/health"
}

variable "web_port" {
  description = "Port where web tier listens"
  type        = number
  default     = 80
}

variable "app_port" {
  description = "Port where app tier listens"
  type        = number
  default     = 4000
}

variable "ec2_instance_type" {
  description = "EC2 instance type for web and app tiers"
  type        = string
  default     = "t3.micro"
}

variable "web_desired_capacity" {
  description = "Desired number of web tier instances"
  type        = number
  default     = 2
}

variable "web_min_size" {
  description = "Minimum number of web tier instances"
  type        = number
  default     = 2
}

variable "web_max_size" {
  description = "Maximum number of web tier instances"
  type        = number
  default     = 4
}

variable "app_desired_capacity" {
  description = "Desired number of app tier instances"
  type        = number
  default     = 2
}

variable "app_min_size" {
  description = "Minimum number of app tier instances"
  type        = number
  default     = 2
}

variable "app_max_size" {
  description = "Maximum number of app tier instances"
  type        = number
  default     = 4
}

variable "app_artifact_s3_key" {
  description = "S3 key for app tier artifact zip"
  type        = string
  default     = "app-tier/app-tier.zip"
}

variable "web_artifact_s3_key" {
  description = "S3 key for web tier artifact zip"
  type        = string
  default     = "web-tier/web-tier.zip"
}

variable "nodejs_major_version" {
  description = "Node.js major version"
  type        = number
  default     = 18
}

variable "enable_waf" {
  description = "Enable AWS WAF for the public ALB"
  type        = bool
  default     = true
}

variable "waf_rate_limit" {
  description = "Maximum requests per 5-minute period from a single IP"
  type        = number
  default     = 1000
}