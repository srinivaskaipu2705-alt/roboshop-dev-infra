output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_submet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_submet_ids" {
  value = module.vpc.private_subnet_ids
}

output "database_submet_ids" {
  value = module.vpc.database_subnet_ids
}