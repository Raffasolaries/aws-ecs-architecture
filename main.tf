# Creates the certificate
resource "aws_acm_certificate" "cert" {
 domain_name       = var.domain
 validation_method = "DNS"
 subject_alternative_names = [join(".", ["*", var.domain])]

 tags = {
  Name = join("-", [var.region, var.domain, "certificate"])
  Environment = "all"
 }

 lifecycle {
  create_before_destroy = true
 }
}