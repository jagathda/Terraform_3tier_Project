resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "test-igw"
    Terraform = "true"
    Environment = "dev"
  }
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "test-vpc"
    Terraform = "true"
    Environment = "dev"
  }
}

//public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "test-public-subnet"
    Terraform = "true"
    Environment = "dev"
  }
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "test-public-route-table"
    Terraform = "true"
    Environment = "dev"
  }
}

resource "aws_route_table_association" "public-rt-association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public-route-table.id
}

//private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "test-private-subnet"
    Terraform = "true"
    Environment = "dev"
  }
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "test-private-route-table"
    Terraform = "true"
    Environment = "dev"
  }
}

resource "aws_route_table_association" "private-rt-association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private-route-table.id
}

//database subnet
resource "aws_subnet" "database_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "test-database-subnet"
    Terraform = "true"
    Environment = "dev"
  }
}

resource "aws_route_table" "database-route-table" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "test-database-route-table"
    Terraform = "true"
    Environment = "dev"
  }
}

resource "aws_route_table_association" "database-rt-association" {
  subnet_id      = aws_subnet.database_subnet.id
  route_table_id = aws_route_table.database-route-table.id
}