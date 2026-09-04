# Αρχείο για τη δημιουργία password και την αποθήκευση των RDS credentials στο AWS Secrets Manager.

# RDS credentials stored in AWS Secrets Manager

# Παράγει τυχαίο password. Terraform όνομα: db_password.
resource "random_password" "db_password" {
  # Ορίζει το μήκος του παραγόμενου password.
  length = 24
  # Επιτρέπει ειδικούς χαρακτήρες στο password.
  special = true
  # Περιορίζει ποιοι ειδικοί χαρακτήρες μπορούν να χρησιμοποιηθούν.
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Create a secret in AWS Secrets Manager to store RDS credentials

# Δημιουργεί secret στο AWS Secrets Manager. Terraform όνομα: db_credentials.
resource "aws_secretsmanager_secret" "db_credentials" {
  # Ορίζει το όνομα του πόρου μέσα στην AWS.
  name = "${var.project_name}/${var.environment}/rds/credentials"
  # Περιγράφει τον σκοπό του πόρου.
  description = "RDS credentials for ${var.project_name}-${var.environment}"

  # Ορίζει πόσες ημέρες μπορεί να γίνει ανάκτηση secret μετά από διαγραφή.
  recovery_window_in_days = 7

  # Tags για οργάνωση, αναζήτηση και κοστολόγηση πόρων στην AWS.
  tags = {
    Name        = "${var.project_name}-${var.environment}-db-secret"
    Environment = var.environment
  }
}

# Store the RDS credentials in the secret

# Αποθηκεύει τιμή μέσα σε secret. Terraform όνομα: db_credentials_version.
resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  # Συνδέει secret version με συγκεκριμένο secret.
  secret_id = aws_secretsmanager_secret.db_credentials.id

  # Αποθηκεύει το περιεχόμενο του secret ως JSON string.
  secret_string = jsonencode({
    # Ορίζει τον master database user.
    username = var.db_username
    # Ορίζει το password του master database user.
    password = random_password.db_password.result
    dbname   = var.db_name
  })
}
