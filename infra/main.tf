resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
}

# Subnet 1
resource "aws_subnet" "public_subnet_1a_cidr" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_1a_cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "public_subnet_1a"
  }
}

# Subnet 2
resource "aws_subnet" "public_subnet_1b_cidr" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_1b_cidr
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false
  tags = {
    Name = "public_subnet_1b"
  }
}


# Subnet 3
resource "aws_subnet" "private_subnet_1a_cidr" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_1a_cidr
  availability_zone = "us-east-1a"
  tags = {
    Name = "private_subnet_1a"
  }
}

# Subnet 4
resource "aws_subnet" "private_subnet_1b_cidr" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_1b_cidr
  availability_zone = "us-east-1b"
  tags = {
    Name = "private_subnet_1b"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }


  tags = {
    Name = "example"
  }
}

resource "aws_route_table_association" "public_subnet_1a_cidr" {
  subnet_id      = aws_subnet.public_subnet_1a_cidr.id
  route_table_id = aws_route_table.public.id

}
resource "aws_route_table_association" "public_subnet_1b_cidr" {
  subnet_id      = aws_subnet.public_subnet_1b_cidr.id
  route_table_id = aws_route_table.public.id

}

