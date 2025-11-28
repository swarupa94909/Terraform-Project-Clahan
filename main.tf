resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "swarupa-vpc"
  }
}
resource "aws_subnet" "main_public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "public subnet"
  }
}
resource "aws_subnet" "main_private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "private subnet"
  }

}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw"
  }
}
 resource"aws_route_table" "swarupa_public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "swarupa_public"
  }
} 

resource "aws_route_table" "swarupa_private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "swarupa_private"
  }
}

# 
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.main_public.id
  route_table_id = aws_route_table.swarupa_public.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.main_private.id
  route_table_id = aws_route_table.swarupa_private.id
}
