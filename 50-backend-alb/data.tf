data "aws_ssm_parameter" "backend-alb_sg_id" {
    name = "/${var.project}/${var.environment}/backend-alb_sg_id"
}
data "aws_ssm_parameter" "Private_subnet_ids" {
    name = "/${var.project}/${var.environment}/Private_subnet_ids"
}