# Create main VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block   # CIDR block for our VPC (e.g., 10.0.0.0/16)
  enable_dns_support   = true                 # Enables DNS support in the VPC
  enable_dns_hostnames = true                 # Enables the use of DNS names for resources in the VPC

  tags = {
    Name = "${var.vpc_name}-vpc"              # Adds a tag that includes the VPC name
  }
}

# Create public subnets
resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)   # Create multiple subnets, the number is determined by the length of the public_subnets list
  vpc_id                  = aws_vpc.main.id              # Associate each subnet with the VPC created earlier
  cidr_block              = var.public_subnets[count.index] # CIDR block for the specific subnet from the public_subnets list
  availability_zone       = var.availability_zones[count.index] # Determine the availability zones for each subnet
  map_public_ip_on_launch = true                         # Automatically assign public IP addresses to instances in the subnet

  tags = {
    Name = "${var.vpc_name}-public-subnet-${count.index + 1}"  # Tag with subnet numbering
    # count.index is the index of the "count" loop, starting from 0.
    # ${count.index + 1} adds +1 to the index to get a human-readable numbering (1, 2, 3 instead of 0, 1, 2).
  }
}

# Create private subnets
resource "aws_subnet" "private" {
  count             = length(var.private_subnets)   # Create multiple private subnets, the number is determined by the length of the private_subnets list
  vpc_id            = aws_vpc.main.id               # Associate each private subnet with the VPC
  cidr_block        = var.private_subnets[count.index] # CIDR block for the specific private subnet from the private_subnets list
  availability_zone = var.availability_zones[count.index] # Determine the availability zones for each private subnet

  tags = {
    Name = "${var.vpc_name}-private-subnet-${count.index + 1}"  # Tag with subnet numbering
    # ${count.index + 1} is used to start subnet numbering from 1.
  }
}

# Create Internet Gateway for public subnets
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id   # Associate Internet Gateway with the VPC for internet access

  tags = {
    Name = "${var.vpc_name}-igw"   # Tag for identifying the Internet Gateway
  }
}

