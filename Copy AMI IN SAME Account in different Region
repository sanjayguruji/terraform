provider "aws" {
  region = "ap-southeast-1" #destination region code
}


##aws ami copy code
resource "aws_ami_copy" "terra-copy-image" {
  name              = "terra-copy-image"
  description       = "A copy of image"
  source_ami_id     = "ami-09630fda22ae67d5d"
  source_ami_region = "ap-south-1"  #source Region code

  tags = {
    Name = "Hello-world"
  }
}
