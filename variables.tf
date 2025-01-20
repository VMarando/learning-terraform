variable "vpc_id" {
  description = "ID of the VPC where to create security group"
  type        = string
  default     = null
}

#------------------------
# VPC
#------------------------
#aws_vpc_tag_name = "ditwl-vpc"
#aws_vpc_block = "172.17.32.0/19" #172.17.32.1 - 172.16.67.254

variable "aws_vpc_cidr_block" {
  description = "AWS CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

#------------------------
# SUBNETS
#------------------------

  #------------------------
  # For EC2 instances
  #------------------------

    #Zone: A, Env: PRO, Type: PUBLIC, Code: 32
    aws_sn_za_pro_pub_00={
      cidr   ="10.0.0.0/24" #172.17.32.1 - 172.17.33.254
      name   ="ditwl-sn-za-pro-pub-00"
      az     ="us-west-1a"
      public = "true"
    }

    #Zone: A, Env: PRO, Type: PRIVATE, Code: 34
    aws_sn_za_pro_pri_08={
      cidr   = "10.0.8.0/24" #172.17.34.1 - 172.17.35.254
      name   = "ditwl-sn-za-pro-pri-08"
      az     = "us-west-1a"
      public = "false"
    }

    #Zone: B, Env: PRO, Type: PUBLIC, Code: 36
    aws_sn_zb_pro_pub_16={
      cidr   = "10.0.16.0/24" #172.17.36.1 - 172.17.37.254
      name   = "ditwl-sn-zb-pro-pub-16"
      az     = "us-west-1b"
      public = "false"
    }

    #Zone: B, Env: PRO, Type: PRIVATE, Code: 38
    aws_sn_zb_pro_pri_24={
      cidr   = "10.0.24.0/24" #172.17.38.1 - 172.17.39.254
      name   = "ditwl-sn-zb-pro-pri-24"
      az     = "us-west-1b"
      public = "false"
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
