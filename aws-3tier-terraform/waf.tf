# Αρχείο για AWS WAF Web ACL και σύνδεσή του με το δημόσιο ALB.

# Δημιουργεί WAF Web ACL. Terraform όνομα: public_alb.
resource "aws_wafv2_web_acl" "public_alb" {
  # Δημιουργεί 0 ή 1 πόρο ανάλογα με συνθήκη.
  count = var.enable_waf ? 1 : 0

  # Ορίζει το όνομα του πόρου μέσα στην AWS.
  name = "${var.project_name}-${var.environment}-public-alb-waf"
  # Περιγράφει τον σκοπό του πόρου.
  description = "WAF Web ACL for the public Application Load Balancer"
  # Ορίζει αν το WAF είναι REGIONAL ή CLOUDFRONT.
  scope = "REGIONAL"

  # Προεπιλεγμένη ενέργεια όταν δεν ταιριάζει κάποιος ειδικός κανόνας.
  default_action {
    # Επιτρέπει την κίνηση/request.
    allow {}
  }

  # Ορίζει κανόνα ή policy block ανάλογα με τον πόρο.
  rule {
    # Ορίζει το όνομα του πόρου μέσα στην AWS.
    name = "AWSManagedRulesAmazonIpReputationList"
    # Ορίζει τη σειρά αξιολόγησης κανόνων WAF.
    priority = 1

    # Ορίζει αν managed rule group θα μετράει ή θα εφαρμόζει actions.
    override_action {
      # Δεν κάνει override την ενέργεια του managed rule group.
      none {}
    }

    # Ορίζει statement μέσα σε policy ή WAF rule.
    statement {
      # Χρησιμοποιεί έτοιμο AWS managed WAF rule group.
      managed_rule_group_statement {
        # Ορίζει το όνομα του πόρου μέσα στην AWS.
        name = "AWSManagedRulesAmazonIpReputationList"
        # Ορίζει τον vendor του managed rule group.
        vendor_name = "AWS"
      }
    }

    # Ρυθμίσεις παρακολούθησης και metrics για WAF.
    visibility_config {
      # Ενεργοποιεί CloudWatch metrics για visibility.
      cloudwatch_metrics_enabled = true
      # Ορίζει το όνομα metric στο CloudWatch.
      metric_name = "${var.project_name}-${var.environment}-ip-reputation"
      # Ενεργοποιεί δείγματα requests για ανάλυση.
      sampled_requests_enabled = true
    }
  }

  # Ορίζει κανόνα ή policy block ανάλογα με τον πόρο.
  rule {
    # Ορίζει το όνομα του πόρου μέσα στην AWS.
    name = "AWSManagedRulesCommonRuleSet"
    # Ορίζει τη σειρά αξιολόγησης κανόνων WAF.
    priority = 2

    # Ορίζει αν managed rule group θα μετράει ή θα εφαρμόζει actions.
    override_action {
      # Μετράει matches χωρίς να μπλοκάρει, χρήσιμο για δοκιμές.
      count {}
    }

    # Ορίζει statement μέσα σε policy ή WAF rule.
    statement {
      # Χρησιμοποιεί έτοιμο AWS managed WAF rule group.
      managed_rule_group_statement {
        # Ορίζει το όνομα του πόρου μέσα στην AWS.
        name = "AWSManagedRulesCommonRuleSet"
        # Ορίζει τον vendor του managed rule group.
        vendor_name = "AWS"
      }
    }

    # Ρυθμίσεις παρακολούθησης και metrics για WAF.
    visibility_config {
      # Ενεργοποιεί CloudWatch metrics για visibility.
      cloudwatch_metrics_enabled = true
      # Ορίζει το όνομα metric στο CloudWatch.
      metric_name = "${var.project_name}-${var.environment}-common"
      # Ενεργοποιεί δείγματα requests για ανάλυση.
      sampled_requests_enabled = true
    }
  }

  # Ορίζει κανόνα ή policy block ανάλογα με τον πόρο.
  rule {
    # Ορίζει το όνομα του πόρου μέσα στην AWS.
    name = "AWSManagedRulesKnownBadInputsRuleSet"
    # Ορίζει τη σειρά αξιολόγησης κανόνων WAF.
    priority = 3

    # Ορίζει αν managed rule group θα μετράει ή θα εφαρμόζει actions.
    override_action {
      # Μετράει matches χωρίς να μπλοκάρει, χρήσιμο για δοκιμές.
      count {}
    }

    # Ορίζει statement μέσα σε policy ή WAF rule.
    statement {
      # Χρησιμοποιεί έτοιμο AWS managed WAF rule group.
      managed_rule_group_statement {
        # Ορίζει το όνομα του πόρου μέσα στην AWS.
        name = "AWSManagedRulesKnownBadInputsRuleSet"
        # Ορίζει τον vendor του managed rule group.
        vendor_name = "AWS"
      }
    }

    # Ρυθμίσεις παρακολούθησης και metrics για WAF.
    visibility_config {
      # Ενεργοποιεί CloudWatch metrics για visibility.
      cloudwatch_metrics_enabled = true
      # Ορίζει το όνομα metric στο CloudWatch.
      metric_name = "${var.project_name}-${var.environment}-known-bad-inputs"
      # Ενεργοποιεί δείγματα requests για ανάλυση.
      sampled_requests_enabled = true
    }
  }

  # Ορίζει κανόνα ή policy block ανάλογα με τον πόρο.
  rule {
    # Ορίζει το όνομα του πόρου μέσα στην AWS.
    name = "AWSManagedRulesSQLiRuleSet"
    # Ορίζει τη σειρά αξιολόγησης κανόνων WAF.
    priority = 4

    # Ορίζει αν managed rule group θα μετράει ή θα εφαρμόζει actions.
    override_action {
      # Δεν κάνει override την ενέργεια του managed rule group.
      none {}
    }

    # Ορίζει statement μέσα σε policy ή WAF rule.
    statement {
      # Χρησιμοποιεί έτοιμο AWS managed WAF rule group.
      managed_rule_group_statement {
        # Ορίζει το όνομα του πόρου μέσα στην AWS.
        name = "AWSManagedRulesSQLiRuleSet"
        # Ορίζει τον vendor του managed rule group.
        vendor_name = "AWS"
      }
    }

    # Ρυθμίσεις παρακολούθησης και metrics για WAF.
    visibility_config {
      # Ενεργοποιεί CloudWatch metrics για visibility.
      cloudwatch_metrics_enabled = true
      # Ορίζει το όνομα metric στο CloudWatch.
      metric_name = "${var.project_name}-${var.environment}-sqli"
      # Ενεργοποιεί δείγματα requests για ανάλυση.
      sampled_requests_enabled = true
    }
  }

  # Ορίζει κανόνα ή policy block ανάλογα με τον πόρο.
  rule {
    # Ορίζει το όνομα του πόρου μέσα στην AWS.
    name = "RateLimitPerIP"
    # Ορίζει τη σειρά αξιολόγησης κανόνων WAF.
    priority = 10

    # Ενέργεια που θα εκτελεστεί όταν ταιριάξει ο κανόνας.
    action {
      # Μπλοκάρει την κίνηση/request.
      block {}
    }

    # Ορίζει statement μέσα σε policy ή WAF rule.
    statement {
      # Κανόνας WAF που μετράει requests ανά IP και εφαρμόζει rate limit.
      rate_based_statement {
        # Ορίζει το όριο requests για rate limiting.
        limit = var.waf_rate_limit
        # Ορίζει με ποιο κλειδί γίνεται το rate aggregation.
        aggregate_key_type = "IP"
      }
    }

    # Ρυθμίσεις παρακολούθησης και metrics για WAF.
    visibility_config {
      # Ενεργοποιεί CloudWatch metrics για visibility.
      cloudwatch_metrics_enabled = true
      # Ορίζει το όνομα metric στο CloudWatch.
      metric_name = "${var.project_name}-${var.environment}-rate-limit"
      # Ενεργοποιεί δείγματα requests για ανάλυση.
      sampled_requests_enabled = true
    }
  }

  # Ρυθμίσεις παρακολούθησης και metrics για WAF.
  visibility_config {
    # Ενεργοποιεί CloudWatch metrics για visibility.
    cloudwatch_metrics_enabled = true
    # Ορίζει το όνομα metric στο CloudWatch.
    metric_name = "${var.project_name}-${var.environment}-public-alb-waf"
    # Ενεργοποιεί δείγματα requests για ανάλυση.
    sampled_requests_enabled = true
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-public-alb-waf"
  })
}

# Συνδέει WAF Web ACL με ALB. Terraform όνομα: public_alb.
resource "aws_wafv2_web_acl_association" "public_alb" {
  # Δημιουργεί 0 ή 1 πόρο ανάλογα με συνθήκη.
  count = var.enable_waf ? 1 : 0

  # Ορίζει σε ποιον πόρο εφαρμόζεται το WAF.
  resource_arn = aws_lb.public_web.arn
  # Συνδέει το Web ACL με τον πόρο.
  web_acl_arn = aws_wafv2_web_acl.public_alb[0].arn
}
