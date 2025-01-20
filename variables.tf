variable "vpc_id" {
  description = "ID of the VPC where to create security group"
  type        = string
  default     = null
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

locals {
  service_tag   = "${var.service_name}-${var.environment}"
  session_token = "${var.service_name}:${var.service_token}"
}
