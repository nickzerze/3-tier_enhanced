# Αρχείο για τα EC2 Launch Templates και την επιλογή Amazon Linux 2023 AMI.

# Αναζητά το κατάλληλο Amazon Linux 2023 AMI που θα χρησιμοποιηθεί στα EC2 instances.
data "aws_ami" "amazon_linux_2023" {
  # Ζητά το πιο πρόσφατο AMI που ταιριάζει στα φίλτρα.
  most_recent = true
  # Περιορίζει τα AMIs στον συγκεκριμένο owner.
  owners = ["amazon"]

  # Φίλτρο αναζήτησης για data source.
  filter {
    # Ορίζει το όνομα του πόρου μέσα στην AWS.
    name = "name"
    # Ορίζει τις τιμές που πρέπει να ταιριάζουν στο filter.
    values = [
      "al2023-ami-*-x86_64"
    ]
  }

  # Φίλτρο αναζήτησης για data source.
  filter {
    # Ορίζει το όνομα του πόρου μέσα στην AWS.
    name = "architecture"
    # Ορίζει τις τιμές που πρέπει να ταιριάζουν στο filter.
    values = [
      "x86_64"
    ]
  }

  # Φίλτρο αναζήτησης για data source.
  filter {
    # Ορίζει το όνομα του πόρου μέσα στην AWS.
    name = "virtualization-type"
    # Ορίζει τις τιμές που πρέπει να ταιριάζουν στο filter.
    values = [
      "hvm"
    ]
  }
}

# Launch Template for App Tier

# Δημιουργεί EC2 launch template. Terraform όνομα: app.
resource "aws_launch_template" "app" {
  # Ορίζει prefix ονόματος ώστε το AWS να δημιουργήσει μοναδικό όνομα.
  name_prefix = "${var.project_name}-${var.environment}-app-"
  # Ορίζει το AMI image με το οποίο θα ξεκινήσει το EC2 instance.
  image_id = data.aws_ami.amazon_linux_2023.id
  # Ορίζει το μέγεθος/τύπο του EC2 instance.
  instance_type = var.ec2_instance_type

  # Σύνδεση EC2 instances με IAM instance profile.
  iam_instance_profile {
    # Ορίζει το όνομα του πόρου μέσα στην AWS.
    name = aws_iam_instance_profile.ec2.name
  }

  # Ορίζει τα Security Groups του RDS ή EC2.
  vpc_security_group_ids = [
    aws_security_group.app.id
  ]

  # Ρυθμίσεις ασφάλειας για EC2 metadata service.
  metadata_options {
    # Ενεργοποιεί το Instance Metadata Service.
    http_endpoint = "enabled"
    # Απαιτεί IMDSv2 tokens για ασφαλέστερη πρόσβαση metadata.
    http_tokens = "required"
    # Ορίζει hop limit για metadata responses.
    http_put_response_hop_limit = 2
  }

  # Περνά startup script που εκτελείται όταν ξεκινά το EC2 instance.
  user_data = base64encode(templatefile("${path.module}/entry-script_app.sh.tpl", {
    aws_region          = var.aws_region
    artifacts_bucket    = aws_s3_bucket.artifacts.bucket
    app_artifact_s3_key = var.app_artifact_s3_key
    db_secret_arn       = aws_secretsmanager_secret.db_credentials.arn
    db_host             = aws_db_instance.main.address
  }))

  # Ορίζει tags που θα περάσουν στα EC2 instances κατά τη δημιουργία.
  tag_specifications {
    # Ορίζει σε ποιον τύπο πόρου εφαρμόζονται τα tags.
    resource_type = "instance"

    tags = merge(local.common_tags, {
      Name = "${var.project_name}-${var.environment}-app"
      Tier = "app"
    })
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-app-launch-template"
  })

  # Lifecycle κανόνες που αλλάζουν τη συμπεριφορά δημιουργίας/διαγραφής.
  lifecycle {
    # Δημιουργεί νέο πόρο πριν καταστρέψει τον παλιό για αποφυγή downtime.
    create_before_destroy = true
  }
}

# Launch Template for Web Tier (similar to App, but with different user data and tags)

# Δημιουργεί EC2 launch template. Terraform όνομα: web.
resource "aws_launch_template" "web" {
  # Ορίζει prefix ονόματος ώστε το AWS να δημιουργήσει μοναδικό όνομα.
  name_prefix = "${var.project_name}-${var.environment}-web-"
  # Ορίζει το AMI image με το οποίο θα ξεκινήσει το EC2 instance.
  image_id = data.aws_ami.amazon_linux_2023.id
  # Ορίζει το μέγεθος/τύπο του EC2 instance.
  instance_type = var.ec2_instance_type

  # Σύνδεση EC2 instances με IAM instance profile.
  iam_instance_profile {
    # Ορίζει το όνομα του πόρου μέσα στην AWS.
    name = aws_iam_instance_profile.ec2.name
  }

  # Ορίζει τα Security Groups του RDS ή EC2.
  vpc_security_group_ids = [
    aws_security_group.web.id
  ]

  # Ρυθμίσεις ασφάλειας για EC2 metadata service.
  metadata_options {
    # Ενεργοποιεί το Instance Metadata Service.
    http_endpoint = "enabled"
    # Απαιτεί IMDSv2 tokens για ασφαλέστερη πρόσβαση metadata.
    http_tokens = "required"
    # Ορίζει hop limit για metadata responses.
    http_put_response_hop_limit = 2
  }

  # Περνά startup script που εκτελείται όταν ξεκινά το EC2 instance.
  user_data = base64encode(templatefile("${path.module}/entry-script_web.sh.tpl", {
    artifacts_bucket      = aws_s3_bucket.artifacts.bucket
    web_artifact_s3_key   = var.web_artifact_s3_key
    internal_alb_dns_name = aws_lb.internal_app.dns_name
  }))

  # Ορίζει tags που θα περάσουν στα EC2 instances κατά τη δημιουργία.
  tag_specifications {
    # Ορίζει σε ποιον τύπο πόρου εφαρμόζονται τα tags.
    resource_type = "instance"

    tags = merge(local.common_tags, {
      Name = "${var.project_name}-${var.environment}-web"
      Tier = "web"
    })
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-web-launch-template"
  })

  # Lifecycle κανόνες που αλλάζουν τη συμπεριφορά δημιουργίας/διαγραφής.
  lifecycle {
    # Δημιουργεί νέο πόρο πριν καταστρέψει τον παλιό για αποφυγή downtime.
    create_before_destroy = true
  }
}
