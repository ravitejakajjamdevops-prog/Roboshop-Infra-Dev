locals {
    catalogue_sg_id = data.aws_ssm_parameter.catalogue_sg_id.value
    Private_subnet_id = split(",", data.aws_ssm_parameter.Private_subnet_ids.value)[0]
    backend-alb_listener_arn = data.aws_ssm_parameter.backend-alb_listener_arn.value
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = {

        Project = var.project
        Environment = var.environment
    }
}