#create EC2 volume code
resource "aws_instance" "web" {
  ami               = "ami-068e0f1a600cd311c"
  availability_zone = "ap-south-1a"
  instance_type     = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}

#create ebs vol code
resource "aws_ebs_volume" "data-vol" {
  availability_zone = "ap-south-1a"
  size              = 16

  tags = {
    Name = "Ebs-Storage"
  }
}
#create ebs attach code
resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.data-vol.id
  instance_id = aws_instance.web.id
 }

#create snapshot

resource "aws_ebs_snapshot" "example_snapshot" {
  volume_id = aws_ebs_volume.data-vol.id

  tags = {
    Name = "HelloWorld_snap"
  }
}
