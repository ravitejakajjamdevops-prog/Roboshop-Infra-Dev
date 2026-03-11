module "roboshop-SG" {
    source = "../../Terraform-aws-SG"
    count = length(var.sg_names)
    project = "roboshop"
    environment = "Dev"
    sg_name = var.sg_names[count.index]
    vpc_id = local.vpc_id
}