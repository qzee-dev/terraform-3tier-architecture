/*
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "nat-eip"
  }
}
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnet1.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private-route-table"
  }
}
resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}
resource "aws_route_table_association" "private_subnet3" {
  subnet_id      = aws_subnet.subnet3.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_subnet4" {
  subnet_id      = aws_subnet.subnet4.id
  route_table_id = aws_route_table.private.id
}

*/
``
