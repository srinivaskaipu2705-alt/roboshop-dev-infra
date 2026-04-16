# This file contains the main configuration for creating an ACM certificate and validating it using Route53.
# We are creating a wildcard certificate for our domain to cover all subdomains.
resource "aws_acm_certificate" "roboshop" {
  domain_name = "*.${var.domain_name}"
  validation_method = "DNS"

    tags = merge(
        local.common_tags,
        {
        Name = "${local.common_name_suffix}-acm" # roboshop-dev-acm
        }
    )

    lifecycle {
      create_before_destroy = true
    }
}

 # We need to create a Route53 record for each domain validation option provided by ACM, so that ACM can validate the ownership of the domain and issue the certificate. 
resource "aws_route53_record" "roboshop" {
  for_each = {
    for dvo in aws_acm_certificate.roboshop.domain_validation_options : dvo.domain_name => {
      name = dvo.resource_record_name
      type = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }

  allow_overwrite = true
  name = each.value.name
  records = [each.value.record]
    ttl = 1
    type = each.value.type
    zone_id = var.zone_id
}

# Validate the ACM certificate using the created Route53 records.
resource "aws_acm_certificate_validation" "roboshop" {
  certificate_arn = aws_acm_certificate.roboshop.arn

    validation_record_fqdns = [
        for record in aws_route53_record.roboshop : record.fqdn
    ]
}