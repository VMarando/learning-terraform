#output "instance_ami" {
#  value = aws_instance.blog.ami
#}

#output "instance_arn" {
#  value = aws_instance.blog.arn
#}

# Store the AMI ID - optional
output "aws-ami-ubuntu-23-04-arm64-minimal-id" {
  value = data.aws_ami.ubuntu-23-04-arm64-minimal.id
}
