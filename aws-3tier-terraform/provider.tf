# Αρχείο ρύθμισης του AWS provider και της περιοχής όπου θα δημιουργηθούν οι πόροι.

# Το provider block ρυθμίζει με ποιο cloud/API θα μιλάει το Terraform.
provider "aws" {
  # Ορίζει την AWS region του provider.
  region = var.aws_region
}
