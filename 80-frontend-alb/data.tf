data "aws_ssm_parameter" "frontend-alb_sg_id" {
    name = "/${var.project}/${var.environment}/frontend-alb_sg_id"
}
data "aws_ssm_parameter" "Public_subnet_ids" {
    name = "/${var.project}/${var.environment}/Public_subnet_ids"
}
data "aws_ssm_parameter" "frotnend-alb_certificate_arn" {
    name = "/${var.project}/${var.environment}/frontend-alb_certificate_arn"
}

