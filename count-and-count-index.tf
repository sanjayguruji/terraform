# Create a file - instances.tf
###

resource "aws_instance" "my-instance" {
  count         = var.instance_count
  ami           = lookup(var.ami,var.aws_region)
  instance_type = var.instance_type

  tags = {
    Name  = element(var.instance_tags, count.index)
    env = "test"
  }
}

## File end here

## Create another file - vars.tf
###
variable "ami" {
  type = map

  default = {
    "us-east-1" = "ami-0b0dcb5067f052a63"
    "ap-south-1" = "ami-074dc0a6f6c764218"
  }
}

variable "instance_count" {
  default = "2"
}

variable "instance_tags" {
  type = list
  default = ["Terraform-1", "Terraform-2"]
}

variable "instance_type" {
  default = "t2.nano"
}

variable "aws_region" {
  default = "ap-south-1"
}

# File end here
