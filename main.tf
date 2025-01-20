data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-tomcat-*-x86_64-hvm-ebs-nami"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["979382823631"] # Bitnami
}



#------------------------
# VPC
#------------------------
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

# Internet Gateway
resource "aws_internet_gateway" "ditwl-ig" {
  vpc_id = aws_vpc.ditlw-vpc.id
  tags = {
    Name = "ditwl-ig"
  }
}

# NAT Gateway Public Availability Zone: A
resource "aws_nat_gateway" "ditwl-ngw-za-pub" {
  subnet_id = aws_subnet.ditwl-sn-za-pro-pub-00.id
  allocation_id = aws_eip.ditwl-eip-ngw-za.id

  tags = {
    Name = "ditwl-ngw-za-pub"
  }

  depends_on = [aws_internet_gateway.ditwl-ig]
}

# EIP for NAT Gateway in AZ A
resource "aws_eip" "ditwl-eip-ngw-za" {
  domain   = "vpc"

  tags = {
    Name = "ditwl-eip-ngw-za"
  }
}

# NAT Gateway Public Availability Zone: B
resource "aws_nat_gateway" "ditwl-ngw-zb-pub" {
  subnet_id = aws_subnet.ditwl-sn-zb-pro-pub-04.id
  allocation_id = aws_eip.ditwl-eip-ngw-zb.id

  tags = {
    Name = "ditwl-ngw-zb-pub"
  }

  depends_on = [aws_internet_gateway.ditwl-ig]
}

# EIP for NAT Gateway in AZ B
resource "aws_eip" "ditwl-eip-ngw-zb" {
  domain   = "vpc"

  tags = {
    Name = "ditwl-eip-ngw-zb"
  }  
}

# Set new main_route_table as main
resource "aws_main_route_table_association" "ditwl-rta-default" {
  vpc_id         = aws_vpc.ditlw-vpc.id
  route_table_id = aws_route_table.ditwl-rt-pub-main.id
}

# Routing table for private subnet in Availability Zone A 
# Using standalone routes resources 
resource "aws_route_table" "ditwl-rt-priv-za" {
  vpc_id = aws_vpc.ditlw-vpc.id
  tags = {
    Name = "ditwl-rt-priv-za"
  }
}

# Route Access to the Internet through NAT  (Av. Zone A)
resource "aws_route" "ditwl-r-rt-priv-za-ngw-za" {
  route_table_id         = aws_route_table.ditwl-rt-priv-za.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.ditwl-ngw-za-pub.id
}

# Routing Table Association for Subnet ditwl-sn-za-pro-pri-02
resource "aws_route_table_association" "ditwl-rta-za-pro-pri-02" {
  subnet_id      = aws_subnet.ditwl-sn-za-pro-pri-02.id
  route_table_id = aws_route_table.ditwl-rt-priv-za.id
}

# Routing table for private subnet in Availability Zone B
# Using standalone routes resources 
resource "aws_route_table" "ditwl-rt-priv-zb" {
  vpc_id = aws_vpc.ditlw-vpc.id

  tags = {
    Name = "ditwl-rt-priv-zb"
  }
}

# Routing Table Association for Subnet ditwl-sn-zb-pro-pri-06
resource "aws_route_table_association" "ditwl-rta-zb-pro-pri-06" {
  subnet_id      = aws_subnet.ditwl-sn-zb-pro-pri-06.id
  route_table_id = aws_route_table.ditwl-rt-priv-zb.id
}

# Route Access to the Internet through NAT (Av. Zone B)
resource "aws_route" "ditwl-r-rt-priv-zb-ngw-zb" {
  route_table_id         = aws_route_table.ditwl-rt-priv-zb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.ditwl-ngw-zb-pub.id
}

resource "aws_instance" "blog" {
  ami           = data.aws_ami.app_ami.id
  instance_type = "t3.nano"
  vpc_security_group_ids = [aws_security_group.blog.id]

  tags = {
    Name = var.instance_type
    name        = var.name
    environment = var.environment
  }
}

# Create a "base" Security Group for EC2 instances
resource "aws_security_group" "ditwl-sg-base-ec2" {
  name        = "ditwl-sg-base-ec2"
  vpc_id      = aws_vpc.ditlw-vpc.id
  description = "Base security Group for EC2 instances"
}

# DANGEROUS!!
# Allow access from the Internet to port 22 (SSH) in the Public EC2 instances
resource "aws_security_group_rule" "ditwl-sr-internet-to-ec2-ssh" {
  security_group_id = aws_security_group.ditwl-sg-base-ec2.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] # Internet
  description       = "Allow access from the Internet to port 22 (SSH)"
}

# Allow access from the Internet for ICMP protocol (e.g. ping) to the EC2 instances
resource "aws_security_group_rule" "ditwl-sr-internet-to-ec2-icmp" {
  security_group_id = aws_security_group.ditwl-sg-base-ec2.id
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"] # Internet
  description       = "Allow access from the Internet for ICMP protocol"
}

# Allow all outbound traffic to the Internet
resource "aws_security_group_rule" "ditwl-sr-all-outbund" {
  security_group_id = aws_security_group.ditwl-sg-base-ec2.id
  type              = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outbound traffic to Internet"
}

# Create a Security Group for the Front end Server
resource "aws_security_group" "ditwl-sg-front-end" {
  name        = "ditwl-sg-front-end"
  vpc_id      = aws_vpc.ditlw-vpc.id
  description = "Front end Server Security"
}

# Allow access from the Internet to port 80 HTTP in the EC2 instances
resource "aws_security_group_rule" "ditwl-sr-internet-to-front-end-http" {
  security_group_id = aws_security_group.ditwl-sg-front-end.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] # Internet
  description       = "Access from the Internet to port 80 in the EC2 instances"
}

# Create a Security Group for the Back-end Server
resource "aws_security_group" "ditwl-sg-back-end" {
  name        = "ditwl-sg-back-end"
  vpc_id      = aws_vpc.ditlw-vpc.id
  description = "Back-end Server Security"
}

# Allow access from the front-end to port 8080 in the back-end API
resource "aws_security_group_rule" "ditwl-sr-front-end-to-api" {
  security_group_id        = aws_security_group.ditwl-sg-back-end.id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ditwl-sg-front-end.id
  description              = "Allow access from the front-end to port 8080 in the back-end API"
}

resource "aws_db_parameter_group" "default" {
  name   = "mariadb"
  family = "mariadb10.6"
}

resource "aws_db_instance" "Testing_mariadb" {
  identifier           = "mariadbdatabase"
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mariadb"
  engine_version       = "10.6.10"
  instance_class       = "db.m6g.large"
  parameter_group_name = "mariadb"
  skip_final_snapshot  = true
  username             = var.username
  password             = var.password
  availability_zone    = "us-east-2a"
  publicly_accessible  = true
  deletion_protection  = false

  tags = {
    name = "TEST MariaDB"
  }
}

