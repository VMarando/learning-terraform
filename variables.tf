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