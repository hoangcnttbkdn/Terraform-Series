#------------------------------------------------------------------------------
# VPC
#----------------------------------------------------------------------------
output "vpc_id" {
  description = "The VPC ID"
  value       = aws_vpc.vpc.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of VPC"
  value       = aws_vpc.vpc.cidr_block
}

output "vpc_default_security_group_id" {
  value       = join("", aws_vpc.vpc.*.default_security_group_id)
  description = "The ID of the security group created by default on VPC creation"
}

output "availability_zones" {
  description = "List of availability zones"
  value       = var.availability_zones
}

#------------------------------------------------------------------------------
# AWS Internet Gateway
#------------------------------------------------------------------------------
output "internet_gateway_id" {
  description = "ID of the generated Internet Gateway"
  value       = aws_internet_gateway.main-igw.id
}

#------------------------------------------------------------------------------
# AWS Subnets - Public
#------------------------------------------------------------------------------
output "public_subnets_ids" {
  description = "List with the Public Subnets IDs"
  value       = aws_subnet.public_subnet.*.id
}

output "public_subnets_route_table_id" {
  description = "ID of the Route Tables used on Public networks"
  value       = aws_route_table_association.public_subnets_route_table.*.id
}

output "nat_gw_ids" {
  description = "List with the IDs of the NAT Gateways created on public subnets to provide internet to private subnets"
  value       = aws_nat_gateway.main-natgw.*.id
}

#------------------------------------------------------------------------------
# AWS Subnets - Private
#------------------------------------------------------------------------------
output "private_subnets_ids" {
  description = "List with the Private Subnets IDs"
  value       = aws_subnet.private_subnet.*.id
}

output "private_subnets_route_table_id" {
  description = "ID of the Route Table used on Private networks"
  value       = aws_route_table_association.private_subnets_route_table.*.id
}