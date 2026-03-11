locals {
    common_tags = {

        Project = var.project
        Environment = var.environment
    }
    # you will get public subnet id in 1a region
    Public_subnet_ids = split(",",data.aws_ssm_parameter.public_subnet_id.value)[0]
    bastion_sg_id = data.aws_ssm_parameter.bastion_sg_id.value
}