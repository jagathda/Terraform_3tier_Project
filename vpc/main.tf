//internet gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-igw"
    Terraform   = "true"
    Environment = "dev"
  }
}

//vpc
resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.dns_support
  enable_dns_hostnames = var.dns_hostnames

  tags = var.tags
}

//public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name        = "${var.project_name}-public-subnet"
    Terraform   = "true"
    Environment = "dev"
  }
}

//public route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name        = "${var.project_name}-public-route-table"
    Terraform   = "true"
    Environment = "dev"
  }
}

//public route table association
resource "aws_route_table_association" "public_rt_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

//private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name        = "${var.project_name}-private-subnet"
    Terraform   = "true"
    Environment = "dev"
  }
}

//private route table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-private-route-table"
    Terraform   = "true"
    Environment = "dev"
  }
}

//private route table association
resource "aws_route_table_association" "private_rt_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

//database subnet
resource "aws_subnet" "database_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name        = "${var.project_name}-database-subnet"
    Terraform   = "true"
    Environment = "dev"
  }
}

//database route table
resource "aws_route_table" "database_route_table" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-database-route-table"
    Terraform   = "true"
    Environment = "dev"
  }
}

//database route table association
resource "aws_route_table_association" "database_rt_association" {
  subnet_id      = aws_subnet.database_subnet.id
  route_table_id = aws_route_table.database_route_table.id
}

/*
//elastic ip
resource "aws_eip" "nat" {
  domain   = "vpc"
}

//nat gateway
resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet.id
}

//private route
resource "aws_route" "private_route" {
  route_table_id            = aws_route_table.private_route_table.id
  destination_cidr_block    = "0.0.0.0./0"
  nat_gateway_id =  aws_nat_gateway.gw.id
}

//database route
resource "aws_route" "database_route" {
  route_table_id            = aws_route_table.database_route_table.id
  destination_cidr_block    = "0.0.0.0./0"
  nat_gateway_id =  aws_nat_gateway.gw.id
}
*/
//##################################################################
//Security group for postgressql RDS, 5432
resource "aws_security_group" "allow_protgressql" {
  name        = "allow_postgressql"
  description = "Allow postgressql inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "TLS from VPC"
    from_port   = var.postgressql_port
    to_port     = var.postgressql_port
    protocol    = "tcp"
    cidr_blocks = var.cidr_list
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = var.tags
}

#EC2 instance will create inside default VPC
#AMI id are diffrent in different regions
resource "aws_instance" "ec2" {
  count = 3
  ami           = "ami-090abff6ae1141d7d"
  instance_type = "t3.micro"
  tags = {
    Name = var.instance_names[count.index]
  }
}

/*
resource "aws_instance" "condition" {
  ami           = "ami-090abff6ae1141d7d"
  instance_type = var.isProd ? "t3.micro" : "t2.micro"
}
*/

resource "aws_instance" "condition" {
  ami           = "ami-090abff6ae1141d7d"
  instance_type = var.env == "PROD" ? "t3.micro" : "t2.micro"
}