# Αρχείο με input variables, δηλαδή παραμέτρους που κάνουν το Terraform project επαναχρησιμοποιήσιμο.

# Variable `aws_region`: AWS region όπου θα δημιουργηθούν οι πόροι.
variable "aws_region" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "AWS region"
  # Ορίζει τον τύπο της τιμής ή της ενέργειας, ανάλογα με το block.
  type = string
  # Ορίζει προεπιλεγμένη τιμή για variable.
  default = "eu-central-1"
}

# Variable `project_name`: Prefix ονόματος για όλους τους πόρους.
variable "project_name" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "Project name prefix"
  # Ορίζει τον τύπο της τιμής ή της ενέργειας, ανάλογα με το block.
  type = string
  # Ορίζει προεπιλεγμένη τιμή για variable.
  default = "aws-3tier"
}

# Variable `environment`: Περιβάλλον deployment, π.χ. dev/prod.
variable "environment" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "Environment name"
  # Ορίζει τον τύπο της τιμής ή της ενέργειας, ανάλογα με το block.
  type = string
  # Ορίζει προεπιλεγμένη τιμή για variable.
  default = "dev"
}

# Variable `domain_name`: Πλήρες domain name της εφαρμογής.
variable "domain_name" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "Application domain name"
  # Ορίζει τον τύπο της τιμής ή της ενέργειας, ανάλογα με το block.
  type = string
}

# Variable `route53_zone_name`: Root domain της Route 53 hosted zone.
variable "route53_zone_name" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "Root domain hosted in Route 53"
  # Ορίζει τον τύπο της τιμής ή της ενέργειας, ανάλογα με το block.
  type = string
}

# Variable `db_name`: Όνομα της MySQL database.
variable "db_name" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "Database name"
  # Ορίζει τον τύπο της τιμής ή της ενέργειας, ανάλογα με το block.
  type = string
  # Ορίζει προεπιλεγμένη τιμή για variable.
  default = "appdb"
}

# Variable `db_username`: Master username της βάσης.
variable "db_username" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "Database master username"
  # Ορίζει τον τύπο της τιμής ή της ενέργειας, ανάλογα με το block.
  type = string
  # Ορίζει προεπιλεγμένη τιμή για variable.
  default = "adminuser"
}

# Variable `db_instance_class`: Τύπος/μέγεθος RDS instance.
variable "db_instance_class" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "RDS instance class"
  # Ορίζει τον τύπο της τιμής ή της ενέργειας, ανάλογα με το block.
  type = string
  # Ορίζει προεπιλεγμένη τιμή για variable.
  default = "db.t4g.micro"
}

# Variable `db_allocated_storage`: Αρχικό storage του RDS σε GB.
variable "db_allocated_storage" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "Allocated storage for RDS in GB"
  # Ορίζει τον τύπο της τιμής ή της ενέργειας, ανάλογα με το block.
  type = number
  # Ορίζει προεπιλεγμένη τιμή για variable.
  default = 20
}

# Variable `db_max_allocated_storage`: Μέγιστο autoscaled storage του RDS σε GB.
variable "db_max_allocated_storage" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "Maximum autoscaled storage for RDS in GB"
  # Ορίζει τον τύπο της τιμής ή της ενέργειας, ανάλογα με το block.
  type = number
  # Ορίζει προεπιλεγμένη τιμή για variable.
  default = 100
}

# Variable `db_backup_retention_period`: Ημέρες διατήρησης automated backups.
variable "db_backup_retention_period" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "Number of days to retain automated backups"
  # Ορίζει τον τύπο της τιμής ή της ενέργειας, ανάλογα με το block.
  type = number
  # Ορίζει προεπιλεγμένη τιμή για variable.
  default = 7
}

# Variable `enable_rds_multi_az`: Ενεργοποίηση Multi-AZ στο RDS.
variable "enable_rds_multi_az" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "Enable Multi-AZ deployment for RDS"
  # Ορίζει τον τύπο της τιμής ή της ενέργειας, ανάλογα με το block.
  type = bool
  # Ορίζει προεπιλεγμένη τιμή για variable.
  default = true
}

# Variable `rds_deletion_protection`: Προστασία του RDS από τυχαία διαγραφή.
variable "rds_deletion_protection" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "Protect the RDS instance from deletion"
  # Ορίζει τον τύπο της τιμής ή της ενέργειας, ανάλογα με το block.
  type = bool
  # Η ασφαλής προεπιλογή απαιτεί ρητή απενεργοποίηση πριν από destroy.
  default = true
}

# Variable `vpc_cidr`: CIDR block του VPC.
variable "vpc_cidr" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "CIDR block for the main VPC"
  # Ορίζει τον τύπο της τιμής ή της ενέργειας, ανάλογα με το block.
  type = string
  # Ορίζει προεπιλεγμένη τιμή για variable.
  default = "10.0.0.0/16"
}

# Variable `public_subnet_az1_cidr`: CIDR για public subnet στην πρώτη AZ.
variable "public_subnet_az1_cidr" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "CIDR block for public subnet in AZ1"
  # Ορίζει τον τύπο της τιμής ή της ενέργειας, ανάλογα με το block.
  type = string
  # Ορίζει προεπιλεγμένη τιμή για variable.
  default = "10.0.1.0/24"
}

# Variable `public_subnet_az2_cidr`: CIDR για public subnet στη δεύτερη AZ.
variable "public_subnet_az2_cidr" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "CIDR block for public subnet in AZ2"
  # Ορίζει τον τύπο της τιμής ή της ενέργειας, ανάλογα με το block.
  type = string
  # Ορίζει προεπιλεγμένη τιμή για variable.
  default = "10.0.2.0/24"
}

# Variable `private_web_subnet_az1_cidr`: CIDR για private web subnet στην πρώτη AZ.
variable "private_web_subnet_az1_cidr" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "CIDR block for private web subnet in AZ1"
  # Ορίζει τον τύπο της τιμής ή της ενέργειας, ανάλογα με το block.
  type = string
  # Ορίζει προεπιλεγμένη τιμή για variable.
  default = "10.0.11.0/24"
}

# Variable `private_web_subnet_az2_cidr`: CIDR για private web subnet στη δεύτερη AZ.
variable "private_web_subnet_az2_cidr" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "CIDR block for private web subnet in AZ2"
  # Ορίζει τον τύπο της τιμής ή της ενέργειας, ανάλογα με το block.
  type = string
  # Ορίζει προεπιλεγμένη τιμή για variable.
  default = "10.0.12.0/24"
}

# Variable `private_app_subnet_az1_cidr`: CIDR για private app subnet στην πρώτη AZ.
variable "private_app_subnet_az1_cidr" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "CIDR block for private app subnet in AZ1"
  # Ορίζει τον τύπο της τιμής ή της ενέργειας, ανάλογα με το block.
  type = string
  # Ορίζει προεπιλεγμένη τιμή για variable.
  default = "10.0.21.0/24"
}

# Variable `private_app_subnet_az2_cidr`: CIDR για private app subnet στη δεύτερη AZ.
variable "private_app_subnet_az2_cidr" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "CIDR block for private app subnet in AZ2"
  # Ορίζει τον τύπο της τιμής ή της ενέργειας, ανάλογα με το block.
  type = string
  # Ορίζει προεπιλεγμένη τιμή για variable.
  default = "10.0.22.0/24"
}

# Variable `private_db_subnet_az1_cidr`: CIDR για private database subnet στην πρώτη AZ.
variable "private_db_subnet_az1_cidr" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "CIDR block for private database subnet in AZ1"
  # Ορίζει τον τύπο της τιμής ή της ενέργειας, ανάλογα με το block.
  type = string
  # Ορίζει προεπιλεγμένη τιμή για variable.
  default = "10.0.31.0/24"
}

# Variable `private_db_subnet_az2_cidr`: CIDR για private database subnet στη δεύτερη AZ.
variable "private_db_subnet_az2_cidr" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "CIDR block for private database subnet in AZ2"
  # Ορίζει τον τύπο της τιμής ή της ενέργειας, ανάλογα με το block.
  type = string
  # Ορίζει προεπιλεγμένη τιμή για variable.
  default = "10.0.32.0/24"
}

# Variable `web_health_check_path`: Path για health check του web tier.
variable "web_health_check_path" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "Health check path for web target group"
  # Ορίζει τον τύπο της τιμής ή της ενέργειας, ανάλογα με το block.
  type = string
  # Ορίζει προεπιλεγμένη τιμή για variable.
  default = "/"
}

# Variable `app_health_check_path`: Path για health check του app tier.
variable "app_health_check_path" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "Health check path for app target group"
  # Ορίζει τον τύπο της τιμής ή της ενέργειας, ανάλογα με το block.
  type = string
  # Ορίζει προεπιλεγμένη τιμή για variable.
  default = "/health"
}

# Variable `web_port`: Port που ακούει το web tier.
variable "web_port" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "Port where web tier listens"
  # Ορίζει τον τύπο της τιμής ή της ενέργειας, ανάλογα με το block.
  type = number
  # Ορίζει προεπιλεγμένη τιμή για variable.
  default = 80
}

# Variable `app_port`: Port που ακούει το app tier.
variable "app_port" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "Port where app tier listens"
  # Ορίζει τον τύπο της τιμής ή της ενέργειας, ανάλογα με το block.
  type = number
  # Ορίζει προεπιλεγμένη τιμή για variable.
  default = 4000
}

# Variable `ec2_instance_type`: EC2 instance type για web και app tiers.
variable "ec2_instance_type" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "EC2 instance type for web and app tiers"
  # Ορίζει τον τύπο της τιμής ή της ενέργειας, ανάλογα με το block.
  type = string
  # Ορίζει προεπιλεγμένη τιμή για variable.
  default = "t3.micro"
}

# Variable `web_desired_capacity`: Επιθυμητό πλήθος web instances.
variable "web_desired_capacity" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "Desired number of web tier instances"
  # Ορίζει τον τύπο της τιμής ή της ενέργειας, ανάλογα με το block.
  type = number
  # Ορίζει προεπιλεγμένη τιμή για variable.
  default = 2
}

# Variable `web_min_size`: Ελάχιστο πλήθος web instances.
variable "web_min_size" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "Minimum number of web tier instances"
  # Ορίζει τον τύπο της τιμής ή της ενέργειας, ανάλογα με το block.
  type = number
  # Ορίζει προεπιλεγμένη τιμή για variable.
  default = 2
}

# Variable `web_max_size`: Μέγιστο πλήθος web instances.
variable "web_max_size" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "Maximum number of web tier instances"
  # Ορίζει τον τύπο της τιμής ή της ενέργειας, ανάλογα με το block.
  type = number
  # Ορίζει προεπιλεγμένη τιμή για variable.
  default = 4
}

# Variable `app_desired_capacity`: Επιθυμητό πλήθος app instances.
variable "app_desired_capacity" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "Desired number of app tier instances"
  # Ορίζει τον τύπο της τιμής ή της ενέργειας, ανάλογα με το block.
  type = number
  # Ορίζει προεπιλεγμένη τιμή για variable.
  default = 2
}

# Variable `app_min_size`: Ελάχιστο πλήθος app instances.
variable "app_min_size" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "Minimum number of app tier instances"
  # Ορίζει τον τύπο της τιμής ή της ενέργειας, ανάλογα με το block.
  type = number
  # Ορίζει προεπιλεγμένη τιμή για variable.
  default = 2
}

# Variable `app_max_size`: Μέγιστο πλήθος app instances.
variable "app_max_size" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "Maximum number of app tier instances"
  # Ορίζει τον τύπο της τιμής ή της ενέργειας, ανάλογα με το block.
  type = number
  # Ορίζει προεπιλεγμένη τιμή για variable.
  default = 4
}

# Variable `app_artifact_s3_key`: S3 key του zip artifact για app tier.
variable "app_artifact_s3_key" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "S3 key for app tier artifact zip"
  # Ορίζει τον τύπο της τιμής ή της ενέργειας, ανάλογα με το block.
  type = string
  # Ορίζει προεπιλεγμένη τιμή για variable.
  default = "app-tier/app-tier.zip"
}

# Variable `web_artifact_s3_key`: S3 key του zip artifact για web tier.
variable "web_artifact_s3_key" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "S3 key for web tier artifact zip"
  # Ορίζει τον τύπο της τιμής ή της ενέργειας, ανάλογα με το block.
  type = string
  # Ορίζει προεπιλεγμένη τιμή για variable.
  default = "web-tier/web-tier.zip"
}

# Variable `nodejs_major_version`: Κύρια έκδοση Node.js που προβλέπεται να χρησιμοποιηθεί.
variable "nodejs_major_version" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "Node.js major version"
  # Ορίζει τον τύπο της τιμής ή της ενέργειας, ανάλογα με το block.
  type = number
  # Ορίζει προεπιλεγμένη τιμή για variable.
  default = 18
}

# Variable `enable_waf`: Ενεργοποίηση AWS WAF μπροστά από το public ALB.
variable "enable_waf" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "Enable AWS WAF for the public ALB"
  # Ορίζει τον τύπο της τιμής ή της ενέργειας, ανάλογα με το block.
  type = bool
  # Ορίζει προεπιλεγμένη τιμή για variable.
  default = true
}

# Variable `waf_rate_limit`: Όριο requests ανά IP σε παράθυρο 5 λεπτών.
variable "waf_rate_limit" {
  # Περιγράφει τον σκοπό του πόρου.
  description = "Maximum requests per 5-minute period from a single IP"
  # Ορίζει τον τύπο της τιμής ή της ενέργειας, ανάλογα με το block.
  type = number
  # Ορίζει προεπιλεγμένη τιμή για variable.
  default = 1000
}
