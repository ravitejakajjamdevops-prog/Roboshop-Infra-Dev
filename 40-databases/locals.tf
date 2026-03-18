locals {
    common_tags = {

        Project = var.project
        Environment = var.environment
    }
    # you will get public subnet id in 1a region
    database_subnet_ids = split(",",data.aws_ssm_parameter.database_subnet_id.value)[0]
    mongodb_sg_id = data.aws_ssm_parameter.mongodb_sg_id.value
    redis_sg_id = data.aws_ssm_parameter.redis_sg_id.value
    mysql_sg_id = data.aws_ssm_parameter.mysql_sg_id.value
    rabbitmq_sg_id = data.aws_ssm_parameter.rabbitmq_sg_id.value
}