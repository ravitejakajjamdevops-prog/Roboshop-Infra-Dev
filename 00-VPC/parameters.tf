resource "aws_ssm_parameter" "vpc_id" {
    name = "/${var.project}/${var.environment}/vpc_id"
    type = "String"
    value = module.VPC.vpc_id
}
resource "aws_ssm_parameter" "Public_subnet_ids" {
    name = "/${var.project}/${var.environment}/Public_subnet_ids"
    type = "StringList"
    value = join(",",module.VPC.Public_subnet_ids)
}
resource "aws_ssm_parameter" "Private_subnet_ids" {
    name = "/${var.project}/${var.environment}/Private_subnet_ids"
    type = "StringList"
    value = join(",",module.VPC.Private_subnet_ids)
}
resource "aws_ssm_parameter" "database_subnet_ids" {
    name = "/${var.project}/${var.environment}/database_subnet_ids"
    type = "StringList"
    value = join(",",module.VPC.database_subnet_ids)
}