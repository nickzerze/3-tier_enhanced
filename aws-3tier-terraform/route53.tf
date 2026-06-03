resource "aws_route53_zone" "main" {
  name = var.route53_zone_name

  tags = {
    Name        = "${var.project_name}-${var.environment}-hosted-zone"
    Environment = var.environment
  }
}