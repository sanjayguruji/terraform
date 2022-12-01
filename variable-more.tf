====== Variables and code in same file
#1 - filename - site.tf

provider "aws" {
	region = "us-east-1"
}

variable "ami" {
	default = "ami-04169656fea786776"
}

variable "instance_type" {
	default = "t2.nano"
}

resource "aws_key_pair" "terraform-demo" {
  key_name   = "terraform-demo"
  public_key = "${file("terraform-demo.pub")}"
}

resource "aws_instance" "my-instance" {
	ami = "${var.ami}"
	instance_type = "${var.instance_type}"
	key_name = "${aws_key_pair.terraform-demo.key_name}"
	user_data = "${file("install_apache.sh")}"
	tags = {
		Name = "Terraform"	
		Batch = "9AM"
	}
}

===== 

==== As project grows, we can put variables and code in separate files

#1 - file for variables - vars.tf

variable "ami" {
	default = "ami-04169656fea786776"
}

variable "instance_type" {
	default = "t2.nano"
}

#2 - file for code - site.tf

provider "aws" {
	region = "us-east-1"
}

resource "aws_key_pair" "terraform-demo" {
  key_name   = "terraform-demo"
  public_key = "${file("terraform-demo.pub")}"
}

resource "aws_instance" "my-instance" {
	ami = "${var.ami}"
	instance_type = "${var.instance_type}"
	key_name = "${aws_key_pair.terraform-demo.key_name}"
	user_data = "${file("install_apache.sh")}"
	tags = {
		Name = "Terraform"	
		Batch = "9AM"
	}
}

#####
