# Αρχείο για IAM role, policies και instance profile που χρησιμοποιούν τα EC2 instances.

# Δημιουργεί IAM role. Terraform όνομα: ec2.
resource "aws_iam_role" "ec2" {
  # Ορίζει το όνομα του πόρου μέσα στην AWS.
  name = "${var.project_name}-${var.environment}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-ec2-role"
  })
}

# Συνδέει IAM policy με IAM role. Terraform όνομα: ssm_core.
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Δημιουργεί custom IAM policy. Terraform όνομα: ec2_app_access.
resource "aws_iam_policy" "ec2_app_access" {
  # Ορίζει το όνομα του πόρου μέσα στην AWS.
  name = "${var.project_name}-${var.environment}-ec2-app-access"
  # Περιγράφει τον σκοπό του πόρου.
  description = "Allow EC2 instances to read deployment artifacts and DB secret"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ReadArtifactsBucket"
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = aws_s3_bucket.artifacts.arn
      },
      {
        Sid    = "ReadArtifactsObjects"
        Effect = "Allow"
        Action = [
          "s3:GetObject"
        ]
        Resource = "${aws_s3_bucket.artifacts.arn}/*"
      },
      {
        Sid    = "ReadDatabaseSecret"
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = aws_secretsmanager_secret.db_credentials.arn
      }
    ]
  })

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-ec2-app-access"
  })
}

# Συνδέει IAM policy με IAM role. Terraform όνομα: ec2_app_access.
resource "aws_iam_role_policy_attachment" "ec2_app_access" {
  role       = aws_iam_role.ec2.name
  policy_arn = aws_iam_policy.ec2_app_access.arn
}

# Δημιουργεί instance profile ώστε EC2 να χρησιμοποιεί IAM role. Terraform όνομα: ec2.
resource "aws_iam_instance_profile" "ec2" {
  # Ορίζει το όνομα του πόρου μέσα στην AWS.
  name = "${var.project_name}-${var.environment}-ec2-instance-profile"
  role = aws_iam_role.ec2.name

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-ec2-instance-profile"
  })
}
