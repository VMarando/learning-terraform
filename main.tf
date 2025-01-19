module "grb_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "dev" 
  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]

  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.11.21.0/24"

  tags = {
    Name = "tf-example"
  }
}

resource "aws_subnet" "QA_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.11.31.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "tf-example"
  }
}

resource "aws_subnet" "DEV_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.11.41.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "tf-example"
  }
}

resource "aws_subnet" "PROD_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.11.51.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "tf-example"
  }
}

### STEP - 2
## SECURITY GROUP
#################
resource "aws_security_group" "blog" {
  name = "blog"
  tags = {
    Terraform = "true"
  }
  vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group_rule" "blog_http_in" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.blog.id
}

resource "aws_security_group_rule" "blog_https_in" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.blog.id
}

resource "aws_security_group_rule" "blog_everything_out" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.blog.id
}