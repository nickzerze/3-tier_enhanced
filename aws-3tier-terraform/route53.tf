# Αρχείο για τη Route 53 hosted zone του domain.

# Δημιουργεί Route 53 hosted zone. Terraform όνομα: main.
resource "aws_route53_zone" "main" {
  # Ορίζει το όνομα του πόρου μέσα στην AWS.
  name = var.route53_zone_name

  # Tags για οργάνωση, αναζήτηση και κοστολόγηση πόρων στην AWS.
  tags = {
    Name        = "${var.project_name}-${var.environment}-hosted-zone"
    Environment = var.environment
  }
}
