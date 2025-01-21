resource "aws_vpc" "ditlw-vpc" {
  cidr_block = "172.21.0.0/19" #172.21.0.0 - 172.21.31.254
  tags = {
    Name = "ditlw-vpc"
  }
}

resource "aws_internet_gateway" "ditwl-ig" {
  vpc_id = aws_vpc.ditlw-vpc.id
}
