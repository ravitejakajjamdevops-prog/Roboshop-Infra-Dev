module "VPC" {
    source = "git::https://github.com/ravitejakajjamdevops-prog/Terraform-aws-VPC.git?ref=main"
    project = var.project
    environment = var.environment
    is_peering_required =  true
}