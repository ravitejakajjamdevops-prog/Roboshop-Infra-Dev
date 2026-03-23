locals {
    frontend-alb_sg_id = data.aws_ssm_parameter.frontend-alb_sg_id.value
    Public_subnet_ids = split(",", data.aws_ssm_parameter.Public_subnet_ids.value)
    common_tags = {

        Project = var.project
        Environment = var.environment
    }
    frotnend-alb_certificate_arn = data.aws_ssm_parameter.frotnend-alb_certificate_arn.value
}