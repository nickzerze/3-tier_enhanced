# Αρχείο για το δίκτυο: VPC, subnets, Internet Gateway, NAT Gateways, route tables και route associations.

# Διαβάζει τις διαθέσιμες Availability Zones της επιλεγμένης AWS region.
data "aws_availability_zones" "available" {
  # Φιλτράρει Availability Zones με βάση την κατάσταση τους.
  state = "available"
}

# Δημιουργεί το βασικό VPC. Terraform όνομα: main.
resource "aws_vpc" "main" {
  # Ορίζει το CIDR block, δηλαδή το εύρος ιδιωτικών IP διευθύνσεων.
  cidr_block = var.vpc_cidr
  # Ενεργοποιεί DNS hostnames μέσα στο VPC.
  enable_dns_hostnames = true
  # Ενεργοποιεί DNS resolution μέσα στο VPC.
  enable_dns_support = true

  # Tags για οργάνωση, αναζήτηση και κοστολόγηση πόρων στην AWS.
  tags = {
    Name        = "${var.project_name}-${var.environment}-vpc"
    Environment = var.environment
  }
}

# Δημιουργεί Internet Gateway για public internet πρόσβαση. Terraform όνομα: main.
resource "aws_internet_gateway" "main" {
  # Συνδέει τον πόρο με το συγκεκριμένο VPC.
  vpc_id = aws_vpc.main.id

  # Tags για οργάνωση, αναζήτηση και κοστολόγηση πόρων στην AWS.
  tags = {
    Name        = "${var.project_name}-${var.environment}-igw"
    Environment = var.environment
  }
}

# Public subnets

# Δημιουργεί subnet μέσα στο VPC. Terraform όνομα: public_az1.
resource "aws_subnet" "public_az1" {
  # Συνδέει τον πόρο με το συγκεκριμένο VPC.
  vpc_id = aws_vpc.main.id
  # Ορίζει το CIDR block, δηλαδή το εύρος ιδιωτικών IP διευθύνσεων.
  cidr_block = var.public_subnet_az1_cidr
  # Ορίζει σε ποια Availability Zone ανήκει το subnet.
  availability_zone = data.aws_availability_zones.available.names[0]
  # Καθορίζει αν τα νέα instances παίρνουν αυτόματα public IP.
  map_public_ip_on_launch = true

  # Tags για οργάνωση, αναζήτηση και κοστολόγηση πόρων στην AWS.
  tags = {
    Name        = "${var.project_name}-${var.environment}-public-az1"
    Environment = var.environment
    Tier        = "public"
  }
}

# Δημιουργεί subnet μέσα στο VPC. Terraform όνομα: public_az2.
resource "aws_subnet" "public_az2" {
  # Συνδέει τον πόρο με το συγκεκριμένο VPC.
  vpc_id = aws_vpc.main.id
  # Ορίζει το CIDR block, δηλαδή το εύρος ιδιωτικών IP διευθύνσεων.
  cidr_block = var.public_subnet_az2_cidr
  # Ορίζει σε ποια Availability Zone ανήκει το subnet.
  availability_zone = data.aws_availability_zones.available.names[1]
  # Καθορίζει αν τα νέα instances παίρνουν αυτόματα public IP.
  map_public_ip_on_launch = true

  # Tags για οργάνωση, αναζήτηση και κοστολόγηση πόρων στην AWS.
  tags = {
    Name        = "${var.project_name}-${var.environment}-public-az2"
    Environment = var.environment
    Tier        = "public"
  }
}

# Private subnets for web tier

# Δημιουργεί subnet μέσα στο VPC. Terraform όνομα: private_web_az1.
resource "aws_subnet" "private_web_az1" {
  # Συνδέει τον πόρο με το συγκεκριμένο VPC.
  vpc_id = aws_vpc.main.id
  # Ορίζει το CIDR block, δηλαδή το εύρος ιδιωτικών IP διευθύνσεων.
  cidr_block = var.private_web_subnet_az1_cidr
  # Ορίζει σε ποια Availability Zone ανήκει το subnet.
  availability_zone = data.aws_availability_zones.available.names[0]
  # Καθορίζει αν τα νέα instances παίρνουν αυτόματα public IP.
  map_public_ip_on_launch = false

  # Tags για οργάνωση, αναζήτηση και κοστολόγηση πόρων στην AWS.
  tags = {
    Name        = "${var.project_name}-${var.environment}-private-web-az1"
    Environment = var.environment
    Tier        = "web"
  }
}

# Δημιουργεί subnet μέσα στο VPC. Terraform όνομα: private_web_az2.
resource "aws_subnet" "private_web_az2" {
  # Συνδέει τον πόρο με το συγκεκριμένο VPC.
  vpc_id = aws_vpc.main.id
  # Ορίζει το CIDR block, δηλαδή το εύρος ιδιωτικών IP διευθύνσεων.
  cidr_block = var.private_web_subnet_az2_cidr
  # Ορίζει σε ποια Availability Zone ανήκει το subnet.
  availability_zone = data.aws_availability_zones.available.names[1]
  # Καθορίζει αν τα νέα instances παίρνουν αυτόματα public IP.
  map_public_ip_on_launch = false

  # Tags για οργάνωση, αναζήτηση και κοστολόγηση πόρων στην AWS.
  tags = {
    Name        = "${var.project_name}-${var.environment}-private-web-az2"
    Environment = var.environment
    Tier        = "web"
  }
}

# Private subnets for app tier

# Δημιουργεί subnet μέσα στο VPC. Terraform όνομα: private_app_az1.
resource "aws_subnet" "private_app_az1" {
  # Συνδέει τον πόρο με το συγκεκριμένο VPC.
  vpc_id = aws_vpc.main.id
  # Ορίζει το CIDR block, δηλαδή το εύρος ιδιωτικών IP διευθύνσεων.
  cidr_block = var.private_app_subnet_az1_cidr
  # Ορίζει σε ποια Availability Zone ανήκει το subnet.
  availability_zone = data.aws_availability_zones.available.names[0]
  # Καθορίζει αν τα νέα instances παίρνουν αυτόματα public IP.
  map_public_ip_on_launch = false

  # Tags για οργάνωση, αναζήτηση και κοστολόγηση πόρων στην AWS.
  tags = {
    Name        = "${var.project_name}-${var.environment}-private-app-az1"
    Environment = var.environment
    Tier        = "app"
  }
}

# Δημιουργεί subnet μέσα στο VPC. Terraform όνομα: private_app_az2.
resource "aws_subnet" "private_app_az2" {
  # Συνδέει τον πόρο με το συγκεκριμένο VPC.
  vpc_id = aws_vpc.main.id
  # Ορίζει το CIDR block, δηλαδή το εύρος ιδιωτικών IP διευθύνσεων.
  cidr_block = var.private_app_subnet_az2_cidr
  # Ορίζει σε ποια Availability Zone ανήκει το subnet.
  availability_zone = data.aws_availability_zones.available.names[1]
  # Καθορίζει αν τα νέα instances παίρνουν αυτόματα public IP.
  map_public_ip_on_launch = false

  # Tags για οργάνωση, αναζήτηση και κοστολόγηση πόρων στην AWS.
  tags = {
    Name        = "${var.project_name}-${var.environment}-private-app-az2"
    Environment = var.environment
    Tier        = "app"
  }
}

# Private subnets for database tier

# Δημιουργεί subnet μέσα στο VPC. Terraform όνομα: private_db_az1.
resource "aws_subnet" "private_db_az1" {
  # Συνδέει τον πόρο με το συγκεκριμένο VPC.
  vpc_id = aws_vpc.main.id
  # Ορίζει το CIDR block, δηλαδή το εύρος ιδιωτικών IP διευθύνσεων.
  cidr_block = var.private_db_subnet_az1_cidr
  # Ορίζει σε ποια Availability Zone ανήκει το subnet.
  availability_zone = data.aws_availability_zones.available.names[0]
  # Καθορίζει αν τα νέα instances παίρνουν αυτόματα public IP.
  map_public_ip_on_launch = false

  # Tags για οργάνωση, αναζήτηση και κοστολόγηση πόρων στην AWS.
  tags = {
    Name        = "${var.project_name}-${var.environment}-private-db-az1"
    Environment = var.environment
    Tier        = "database"
  }
}

# Δημιουργεί subnet μέσα στο VPC. Terraform όνομα: private_db_az2.
resource "aws_subnet" "private_db_az2" {
  # Συνδέει τον πόρο με το συγκεκριμένο VPC.
  vpc_id = aws_vpc.main.id
  # Ορίζει το CIDR block, δηλαδή το εύρος ιδιωτικών IP διευθύνσεων.
  cidr_block = var.private_db_subnet_az2_cidr
  # Ορίζει σε ποια Availability Zone ανήκει το subnet.
  availability_zone = data.aws_availability_zones.available.names[1]
  # Καθορίζει αν τα νέα instances παίρνουν αυτόματα public IP.
  map_public_ip_on_launch = false

  # Tags για οργάνωση, αναζήτηση και κοστολόγηση πόρων στην AWS.
  tags = {
    Name        = "${var.project_name}-${var.environment}-private-db-az2"
    Environment = var.environment
    Tier        = "database"
  }
}

# NAT gateways

# Δημιουργεί Elastic IP. Terraform όνομα: nat_az1.
resource "aws_eip" "nat_az1" {
  # Δηλώνει ότι η Elastic IP προορίζεται για χρήση σε VPC.
  domain = "vpc"

  # Tags για οργάνωση, αναζήτηση και κοστολόγηση πόρων στην AWS.
  tags = {
    Name        = "${var.project_name}-${var.environment}-nat-eip-az1"
    Environment = var.environment
  }
}

# Δημιουργεί Elastic IP. Terraform όνομα: nat_az2.
resource "aws_eip" "nat_az2" {
  # Δηλώνει ότι η Elastic IP προορίζεται για χρήση σε VPC.
  domain = "vpc"

  # Tags για οργάνωση, αναζήτηση και κοστολόγηση πόρων στην AWS.
  tags = {
    Name        = "${var.project_name}-${var.environment}-nat-eip-az2"
    Environment = var.environment
  }
}

# Δημιουργεί NAT Gateway για outbound internet από private subnets. Terraform όνομα: az1.
resource "aws_nat_gateway" "az1" {
  # Συνδέει το NAT Gateway με την Elastic IP.
  allocation_id = aws_eip.nat_az1.id
  # Ορίζει σε ποιο subnet θα δημιουργηθεί ή θα συνδεθεί ο πόρος.
  subnet_id = aws_subnet.public_az1.id

  # Επιβάλλει σειρά δημιουργίας πόρων όταν υπάρχει εξάρτηση.
  depends_on = [aws_internet_gateway.main]

  # Tags για οργάνωση, αναζήτηση και κοστολόγηση πόρων στην AWS.
  tags = {
    Name        = "${var.project_name}-${var.environment}-nat-az1"
    Environment = var.environment
  }
}

# Δημιουργεί NAT Gateway για outbound internet από private subnets. Terraform όνομα: az2.
resource "aws_nat_gateway" "az2" {
  # Συνδέει το NAT Gateway με την Elastic IP.
  allocation_id = aws_eip.nat_az2.id
  # Ορίζει σε ποιο subnet θα δημιουργηθεί ή θα συνδεθεί ο πόρος.
  subnet_id = aws_subnet.public_az2.id

  # Επιβάλλει σειρά δημιουργίας πόρων όταν υπάρχει εξάρτηση.
  depends_on = [aws_internet_gateway.main]

  # Tags για οργάνωση, αναζήτηση και κοστολόγηση πόρων στην AWS.
  tags = {
    Name        = "${var.project_name}-${var.environment}-nat-az2"
    Environment = var.environment
  }
}

# Route tables  
#   Public route table

# Δημιουργεί route table. Terraform όνομα: public.
resource "aws_route_table" "public" {
  # Συνδέει τον πόρο με το συγκεκριμένο VPC.
  vpc_id = aws_vpc.main.id

  # Tags για οργάνωση, αναζήτηση και κοστολόγηση πόρων στην AWS.
  tags = {
    Name        = "${var.project_name}-${var.environment}-public-rt"
    Environment = var.environment
  }
}

# Προσθέτει route σε route table. Terraform όνομα: public_internet_access.
resource "aws_route" "public_internet_access" {
  # Ορίζει ποιο route table τροποποιείται ή συνδέεται.
  route_table_id = aws_route_table.public.id
  # Ορίζει τον προορισμό της διαδρομής, π.χ. 0.0.0.0/0 για Internet.
  destination_cidr_block = "0.0.0.0/0"
  # Στέλνει την κίνηση προς Internet Gateway.
  gateway_id = aws_internet_gateway.main.id
}

# Συνδέει subnet με route table. Terraform όνομα: public_az1.
resource "aws_route_table_association" "public_az1" {
  # Ορίζει σε ποιο subnet θα δημιουργηθεί ή θα συνδεθεί ο πόρος.
  subnet_id = aws_subnet.public_az1.id
  # Ορίζει ποιο route table τροποποιείται ή συνδέεται.
  route_table_id = aws_route_table.public.id
}

# Συνδέει subnet με route table. Terraform όνομα: public_az2.
resource "aws_route_table_association" "public_az2" {
  # Ορίζει σε ποιο subnet θα δημιουργηθεί ή θα συνδεθεί ο πόρος.
  subnet_id = aws_subnet.public_az2.id
  # Ορίζει ποιο route table τροποποιείται ή συνδέεται.
  route_table_id = aws_route_table.public.id
}

# Private route tables for AZ1

# Δημιουργεί route table. Terraform όνομα: private_az1.
resource "aws_route_table" "private_az1" {
  # Συνδέει τον πόρο με το συγκεκριμένο VPC.
  vpc_id = aws_vpc.main.id

  # Tags για οργάνωση, αναζήτηση και κοστολόγηση πόρων στην AWS.
  tags = {
    Name        = "${var.project_name}-${var.environment}-private-rt-az1"
    Environment = var.environment
  }
}

# Προσθέτει route σε route table. Terraform όνομα: private_az1_nat_access.
resource "aws_route" "private_az1_nat_access" {
  # Ορίζει ποιο route table τροποποιείται ή συνδέεται.
  route_table_id = aws_route_table.private_az1.id
  # Ορίζει τον προορισμό της διαδρομής, π.χ. 0.0.0.0/0 για Internet.
  destination_cidr_block = "0.0.0.0/0"
  # Στέλνει την outbound κίνηση ιδιωτικών subnets προς NAT Gateway.
  nat_gateway_id = aws_nat_gateway.az1.id
}

# Συνδέει subnet με route table. Terraform όνομα: private_web_az1.
resource "aws_route_table_association" "private_web_az1" {
  # Ορίζει σε ποιο subnet θα δημιουργηθεί ή θα συνδεθεί ο πόρος.
  subnet_id = aws_subnet.private_web_az1.id
  # Ορίζει ποιο route table τροποποιείται ή συνδέεται.
  route_table_id = aws_route_table.private_az1.id
}

# Συνδέει subnet με route table. Terraform όνομα: private_app_az1.
resource "aws_route_table_association" "private_app_az1" {
  # Ορίζει σε ποιο subnet θα δημιουργηθεί ή θα συνδεθεί ο πόρος.
  subnet_id = aws_subnet.private_app_az1.id
  # Ορίζει ποιο route table τροποποιείται ή συνδέεται.
  route_table_id = aws_route_table.private_az1.id
}

# Private route tables for AZ2

# Δημιουργεί route table. Terraform όνομα: private_az2.
resource "aws_route_table" "private_az2" {
  # Συνδέει τον πόρο με το συγκεκριμένο VPC.
  vpc_id = aws_vpc.main.id

  # Tags για οργάνωση, αναζήτηση και κοστολόγηση πόρων στην AWS.
  tags = {
    Name        = "${var.project_name}-${var.environment}-private-rt-az2"
    Environment = var.environment
  }
}

# Προσθέτει route σε route table. Terraform όνομα: private_az2_nat_access.
resource "aws_route" "private_az2_nat_access" {
  # Ορίζει ποιο route table τροποποιείται ή συνδέεται.
  route_table_id = aws_route_table.private_az2.id
  # Ορίζει τον προορισμό της διαδρομής, π.χ. 0.0.0.0/0 για Internet.
  destination_cidr_block = "0.0.0.0/0"
  # Στέλνει την outbound κίνηση ιδιωτικών subnets προς NAT Gateway.
  nat_gateway_id = aws_nat_gateway.az2.id
}

# Συνδέει subnet με route table. Terraform όνομα: private_web_az2.
resource "aws_route_table_association" "private_web_az2" {
  # Ορίζει σε ποιο subnet θα δημιουργηθεί ή θα συνδεθεί ο πόρος.
  subnet_id = aws_subnet.private_web_az2.id
  # Ορίζει ποιο route table τροποποιείται ή συνδέεται.
  route_table_id = aws_route_table.private_az2.id
}

# Συνδέει subnet με route table. Terraform όνομα: private_app_az2.
resource "aws_route_table_association" "private_app_az2" {
  # Ορίζει σε ποιο subnet θα δημιουργηθεί ή θα συνδεθεί ο πόρος.
  subnet_id = aws_subnet.private_app_az2.id
  # Ορίζει ποιο route table τροποποιείται ή συνδέεται.
  route_table_id = aws_route_table.private_az2.id
}

# Private route table for database subnets (no internet access)

# Δημιουργεί route table. Terraform όνομα: private_db.
resource "aws_route_table" "private_db" {
  # Συνδέει τον πόρο με το συγκεκριμένο VPC.
  vpc_id = aws_vpc.main.id

  # Tags για οργάνωση, αναζήτηση και κοστολόγηση πόρων στην AWS.
  tags = {
    Name        = "${var.project_name}-${var.environment}-private-db-rt"
    Environment = var.environment
  }
}

# Συνδέει subnet με route table. Terraform όνομα: private_db_az1.
resource "aws_route_table_association" "private_db_az1" {
  # Ορίζει σε ποιο subnet θα δημιουργηθεί ή θα συνδεθεί ο πόρος.
  subnet_id = aws_subnet.private_db_az1.id
  # Ορίζει ποιο route table τροποποιείται ή συνδέεται.
  route_table_id = aws_route_table.private_db.id
}

# Συνδέει subnet με route table. Terraform όνομα: private_db_az2.
resource "aws_route_table_association" "private_db_az2" {
  # Ορίζει σε ποιο subnet θα δημιουργηθεί ή θα συνδεθεί ο πόρος.
  subnet_id = aws_subnet.private_db_az2.id
  # Ορίζει ποιο route table τροποποιείται ή συνδέεται.
  route_table_id = aws_route_table.private_db.id
}
