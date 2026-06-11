 # Create route table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id  # Associate the route table with our VPC

  tags = {
    Name = "${var.vpc_name}-public-rt"  # Tag for the route table
  }
}

# Create route table for private subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
}

# Add route for internet access through Internet Gateway
resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id  # Route table ID
  destination_cidr_block = "0.0.0.0/0"               # All IP addresses
  gateway_id             = aws_internet_gateway.igw.id  # Specify Internet Gateway as the exit
}

# Route through NAT Gateway for private subnets
resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

# Associate the route table with public subnets
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)  # Associate each subnet
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Associate the route table with private subnets
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
