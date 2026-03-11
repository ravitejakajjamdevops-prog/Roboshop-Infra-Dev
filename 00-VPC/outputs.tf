output "vpc_id" {
    value = module.VPC.vpc_id
}
output "Public_subnet_ids" {
    value = module.VPC.Public_subnet_ids
}
output "Private_subnet_ids" {
    value = module.VPC.Private_subnet_ids
}
output "database_subnet_ids" {
    value = module.VPC.database_subnet_ids
}

