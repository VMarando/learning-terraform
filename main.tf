resource "aws_vpc" "ditlw-vpc" {
  cidr_block = "172.21.0.0/19" #172.21.0.0 - 172.21.31.254
  tags = {
    Name = "ditlw-vpc"
  }
}

resource "aws_internet_gateway" "ditwl-ig" {
  vpc_id = aws_vpc.ditlw-vpc.id
}

# Av. Zone: A, Env: PRO, Type: PUBLIC, Code: 00, CIDR Block: 172.21.0.0/23
resource "aws_subnet" "ditwl-sn-za-pro-pub-00" {
  vpc_id                  = aws_vpc.ditlw-vpc.id
  cidr_block              = "172.21.0.0/23" #172.21.0.0 - 172.21.1.255
  map_public_ip_on_launch = true
  availability_zone       = "us-west-1a"
  tags = {
    Name = "ditwl-sn-za-pro-pub-00"
  }
}

# Av. Zone: A, Env: PRO, Type: PRIVATE, Code: 02, CIDR Block: 172.21.2.0/23
resource "aws_subnet" "ditwl-sn-za-pro-pri-02" {
  vpc_id                  = aws_vpc.ditlw-vpc.id
  cidr_block              = "172.21.2.0/23" #172.21.2.0 - 172.21.3.255
  map_public_ip_on_launch = false
  availability_zone       = "us-west-1a"
  tags = {
    Name = "ditwl-sn-za-pro-pri-02"
  }
}

# Av. Zone: B, Env: PRO, Type: PUBLIC, Code: 04, CIDR Block: 172.21.4.0/23
resource "aws_subnet" "ditwl-sn-zb-pro-pub-04" {
  vpc_id                  = aws_vpc.ditlw-vpc.id
  cidr_block              = "172.21.4.0/23" #172.21.4.0 - 172.21.5.255
  map_public_ip_on_launch = true
  availability_zone       = "us-west-1b"
  tags = {
    Name = "ditwl-sn-zb-pro-pub-04"
  }
}

# Av. Zone: B, Env: PRO, Type: PRIVATE, Code: 06, CIDR Block: 172.21.6.0/23
resource "aws_subnet" "ditwl-sn-zb-pro-pri-06" {
  vpc_id                  = aws_vpc.ditlw-vpc.id
  cidr_block              = "172.21.6.0/23" #172.21.6.0 - 172.21.7.255    
  map_public_ip_on_launch = false
  availability_zone       = "us-west-1b"
  tags = {
    Name = "ditwl-sn-zb-pro-pri-06"
  }
}