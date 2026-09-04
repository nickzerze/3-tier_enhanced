# Αρχείο με τις απαιτούμενες εκδόσεις Terraform και providers.

# Το terraform block ορίζει απαιτήσεις έκδοσης και providers.
terraform {
  # Ορίζει την ελάχιστη έκδοση Terraform.
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      # Ορίζει από πού κατεβαίνει ο provider.
      source = "hashicorp/aws"
      # Ορίζει έκδοση αντικειμένου, policy ή provider.
      version = "~> 6.0"
    }

    random = {
      # Ορίζει από πού κατεβαίνει ο provider.
      source = "hashicorp/random"
      # Ορίζει έκδοση αντικειμένου, policy ή provider.
      version = "~> 3.6"
    }
  }
}
