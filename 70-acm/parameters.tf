
resource "aws_ssm_parameter" "frotnend-alb_certificate_arn" {
  name  = "/${var.project}/${var.environment}/frontend-alb_certificate_arn"
  type  = "String"
  value = aws_acm_certificate.main.arn
}
