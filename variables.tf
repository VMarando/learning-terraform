variable "vpc_id" {
  description = "ID of the VPC where to create security group"
  type        = string
  default     = null
}

#------------------------
# VPC
#------------------------
# Av. Zone: A, Env: PRO, Type: PUBLIC, Code: 00, CIDR Block: 172.21.0.0/23
variable "aws_subnet" "ditwl-sn-za-pro-pub-00" {
  vpc_id                  = aws_vpc.ditlw-vpc.id
  cidr_block              = "172.21.0.0/23" #172.21.0.0 - 172.21.1.255
  map_public_ip_on_launch = true
  availability_zone       = "us-west-1a"
  tags = {
    Name = "ditwl-sn-za-pro-pub-00"
  }
}

# Av. Zone: A, Env: PRO, Type: PRIVATE, Code: 02, CIDR Block: 172.21.2.0/23
variable "aws_subnet" "ditwl-sn-za-pro-pri-02" {
  vpc_id                  = aws_vpc.ditlw-vpc.id
  cidr_block              = "172.21.2.0/23" #172.21.2.0 - 172.21.3.255
  map_public_ip_on_launch = false
  availability_zone       = "us-west-1a"
  tags = {
    Name = "ditwl-sn-za-pro-pri-02"
  }
}

# Av. Zone: B, Env: PRO, Type: PUBLIC, Code: 04, CIDR Block: 172.21.4.0/23
variable "aws_subnet" "ditwl-sn-zb-pro-pub-04" {
  vpc_id                  = aws_vpc.ditlw-vpc.id
  cidr_block              = "172.21.4.0/23" #172.21.4.0 - 172.21.5.255
  map_public_ip_on_launch = true
  availability_zone       = "us-west-1b"
  tags = {
    Name = "ditwl-sn-zb-pro-pub-04"
  }
}

# Av. Zone: B, Env: PRO, Type: PRIVATE, Code: 06, CIDR Block: 172.21.6.0/23
variable "aws_subnet" "ditwl-sn-zb-pro-pri-06" {
  vpc_id                  = aws_vpc.ditlw-vpc.id
  cidr_block              = "172.21.6.0/23" #172.21.6.0 - 172.21.7.255    
  map_public_ip_on_launch = false
  availability_zone       = "us-west-1b"
  tags = {
    Name = "ditwl-sn-zb-pro-pri-06"
  }
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

 variable "instance_type" {
  description = "Type of EC2 instance to provision"
  type        = string
  default     = "t3.nano"
}

variable "rdms_name" {
  type    = string
  default = "mariadb_10.6"
}

variable "service_name" {
  type    = string
  default = "forum"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "service_token" {
  type      = string
  ephemeral = true
}

locals {
  service_tag   = "${var.service_name}-${var.environment}"
  session_token = "${var.service_name}:${var.service_token}"
}
