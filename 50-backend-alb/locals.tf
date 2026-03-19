locals {
    backend-alb_sg_id = data.aws_ssm_parameter.backend-alb_sg_id.value
    Private_subnet_ids = split(",", data.aws_ssm_parameter.Private_subnet_ids.value)
    common_tags = {

        Project = var.project
        Environment = var.environment
    }
}