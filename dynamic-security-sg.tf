resource "aws_security_group" "Jenkins-VM-SG" {
  name        = "Jenkins-VM-SG"
  description = "Allow TLS inbound traffic"

  ingress = [
    for port in [22, 80, 443, 8080, 9000, 3000, 8081, 8082] : {
      description      = "inbound rules"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jenkins-VM-SG"
  }
}

resource "aws_instance" "web-server" {
  ami               = "ami-0447a12f28fddb066"
  availability_zone = "ap-south-1a"
  instance_type     = "t2.micro"
  security_groups   = ["${aws_security_group.Jenkins-VM-SG.name}"]
  tags = {
    Name     = "hello-World"
    Stage    = "testing"
    Location = "INDIA"
  }

}
