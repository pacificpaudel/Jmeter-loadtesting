# TF outputs for tf apply-process/submodules/etc.

# VPC Outputs
output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "vpc_cidr" {
  value = "${module.vpc.vpc_cidr_block}"
}

output "public_subnets" {
  value = ["${module.vpc.public_subnets}"]
}

output "private_subnets" {
  value = ["${module.vpc.private_subnets}"]
}

output "public_route_table_ids" {
  value = ["${module.vpc.public_route_table_ids}"]
}

output "private_route_tables_ids" {
  value = ["${module.vpc.private_route_table_ids}"]
}

output "loadtest_eip" {
  value = [ aws_eip.loadtest_eip.public_ip ]
}

# EC2 Outputs
output "loadtest_server_ids" {
  value = ["${module.loadtest_server.id}"]
}

output "loadtest_server_public_dns" {
  value = ["${module.loadtest_server.public_dns}"]
}

output "loadtest_server_public_ip" {
  value = ["${module.loadtest_server.public_ip}"]
}

output "loadtest_server_private_ip" {
  value = ["${module.loadtest_server.private_ip}"]
}


