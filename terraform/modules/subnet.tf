resource "aws_subnet" "k8s_network" {
  vpc_id                  = aws_vpc.vpc_k8s.id
  cidr_block              = var.public_cidr_block
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone
  tags = {
    Name = "K8s subnet"
  }
}

resource "aws_internet_gateway" "igw_teste" {
  vpc_id = aws_vpc.vpc_k8s.id
  tags = {
    Name = "Internet gateway teste"
  }

}

resource "aws_route_table" "public_teste" {
  vpc_id = aws_vpc.vpc_k8s.id
  tags = {
    Name = "Public Route table"
  }
}

resource "aws_route" "route_internet_gateway" {
  route_table_id         = aws_route_table.public_teste.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_teste.id
}

resource "aws_route_table_association" "Public_association" {
  subnet_id      = aws_subnet.k8s_network.id
  route_table_id = aws_route_table.public_teste.id
}
