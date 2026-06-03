locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

  public_subnet_ids = [
    aws_subnet.public_az1.id,
    aws_subnet.public_az2.id
  ]

  private_web_subnet_ids = [
    aws_subnet.private_web_az1.id,
    aws_subnet.private_web_az2.id
  ]

  private_app_subnet_ids = [
    aws_subnet.private_app_az1.id,
    aws_subnet.private_app_az2.id
  ]

  private_db_subnet_ids = [
    aws_subnet.private_db_az1.id,
    aws_subnet.private_db_az2.id
  ]
}