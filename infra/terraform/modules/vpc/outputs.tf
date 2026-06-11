# Main VPC
output "vpc_id" {
  value       = aws_vpc.main.id
  description = "ID of the main VPC"
}

# Public subnets
output "public_subnet_ids" {
  value       = aws_subnet.public[*].id
  description = "IDs of public subnets"
}

# Private subnets
output "private_subnet_ids" {
  value       = aws_subnet.private[*].id
  description = "IDs of private subnets"
}

# Internet Gateway
output "internet_gateway_id" {
  value       = aws_internet_gateway.igw.id
  description = "ID of the Internet Gateway"
}

# Public route table
output "public_route_table_id" {
  value       = aws_route_table.public.id
  description = "ID of the public route table"
}

# NAT Gateway
output "nat_gateway_id" {
  value = aws_nat_gateway.nat.id
}

# Private route table
output "private_route_table_id" {
  value = aws_route_table.private.id
}