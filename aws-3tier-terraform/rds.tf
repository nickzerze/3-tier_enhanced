# Αρχείο για το RDS MySQL database tier και το DB subnet group.

# Δημιουργεί DB subnet group για RDS. Terraform όνομα: main.
resource "aws_db_subnet_group" "main" {
  # Ορίζει το όνομα του πόρου μέσα στην AWS.
  name = "${var.project_name}-${var.environment}-db-subnet-group"
  # Ορίζει τη λίστα subnets που θα χρησιμοποιηθούν από τον πόρο.
  subnet_ids = local.private_db_subnet_ids

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-db-subnet-group"
  })
}

# RDS instance

# Δημιουργεί RDS database instance. Terraform όνομα: main.
resource "aws_db_instance" "main" {
  # Ορίζει μοναδικό identifier για το RDS instance.
  identifier = "${var.project_name}-${var.environment}-mysql"

  # Ορίζει τη database engine.
  engine = "mysql"
  # Ορίζει την έκδοση της database engine.
  engine_version = "8.0"
  # Ορίζει το μέγεθος/κλάση του RDS instance.
  instance_class = var.db_instance_class

  # Ορίζει τον αρχικό αποθηκευτικό χώρο σε GB.
  allocated_storage = var.db_allocated_storage
  # Ορίζει το μέγιστο autoscaled storage σε GB.
  max_allocated_storage = var.db_max_allocated_storage
  # Ορίζει τον τύπο storage του RDS.
  storage_type = "gp3"
  # Ενεργοποιεί encryption στο RDS storage.
  storage_encrypted = true

  # Ορίζει το αρχικό database name.
  db_name = var.db_name
  # Ορίζει τον master database user.
  username = var.db_username
  # Ορίζει το password του master database user.
  password = random_password.db_password.result

  # Ορίζει σε ποιο DB subnet group θα μπει το RDS.
  db_subnet_group_name = aws_db_subnet_group.main.name
  # Ορίζει τα Security Groups του RDS ή EC2.
  vpc_security_group_ids = [aws_security_group.rds.id]

  # Καθορίζει αν το RDS είναι προσβάσιμο δημόσια.
  publicly_accessible = false
  # Ενεργοποιεί ή απενεργοποιεί Multi-AZ deployment.
  multi_az = var.enable_rds_multi_az

  # Ορίζει για πόσες ημέρες κρατούνται backups.
  backup_retention_period = var.db_backup_retention_period
  # Ορίζει το χρονικό παράθυρο για automated backups.
  backup_window = "02:00-03:00"
  # Ορίζει το χρονικό παράθυρο για maintenance.
  maintenance_window = "sun:03:00-sun:04:00"

  # Επιτρέπει αυτόματες minor version αναβαθμίσεις.
  auto_minor_version_upgrade = true
  # Προστατεύει το RDS από τυχαία διαγραφή.
  deletion_protection = var.rds_deletion_protection

  # Ορίζει αν θα παραλειφθεί final snapshot στη διαγραφή.
  skip_final_snapshot = false
  # Ορίζει το όνομα του final snapshot.
  final_snapshot_identifier = "${var.project_name}-${var.environment}-mysql-final-snapshot"

  # Tags για οργάνωση, αναζήτηση και κοστολόγηση πόρων στην AWS.
  tags = {
    Name        = "${var.project_name}-${var.environment}-mysql"
    Environment = var.environment
  }
}
