resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
}

# Subnet 1
resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet1
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-1"
  }
}

# Subnet 2
resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet2
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-2"
  }
}


# Subnet 3
resource "aws_subnet" "subnet3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet3
  availability_zone = "us-east-1a"
  tags = {
    Name = "subnet-3"
  }
}

# Subnet 4
resource "aws_subnet" "subnet4" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet4
  availability_zone = "us-east-1b"
  tags = {
    Name = "subnet-2"
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

resource "aws_route_table_association" "subnet1" {
    subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.public.id
  
}
resource "aws_route_table_association" "subnet2" {
    subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.public.id
  
}

