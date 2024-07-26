provider "aws" {
  region = "ap-southeast-1"

}

#This is VPC code

resource "aws_vpc" "test-vpc" {
  cidr_block = "10.0.0.0/16"
}

# this is Subnet code
resource "aws_subnet" "public-subnet" {
  vpc_id     = aws_vpc.test-vpc.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "Public-subnet"
  }
}


resource "aws_subnet" "private-subnet" {
  vpc_id     = aws_vpc.test-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Private-subnet" #security group
  }
}
resource "aws_security_group" "test_access" {
  name        = "test_access"
  vpc_id      = aws_vpc.test-vpc.id
  description = "allow ssh and http"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


}
#security group end here#internet gateway code
resource "aws_internet_gateway" "test-igw" {
  vpc_id = aws_vpc.test-vpc.id

  tags = {
    Name = "test-igw"
  }
}


#Public route table code

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.test-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test-igw.id
  }


  tags = {
    Name = "public-rt"

  }
}
#route Tatable assosication code
resource "aws_route_table_association" "public-asso" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-rt.id
}
#ec2 code
resource "aws_instance" "sanjay-server" {
  ami             = "ami-05caa5aa0186b660f"
  subnet_id       = aws_subnet.public-subnet.id
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.test_access.id}"]
  key_name        = "ltitestkey"
  tags = {
    Name     = "test-World"
    Stage    = "testing"
    Location = "chennai"
  }

}


##create an EIP for EC2
resource "aws_eip" "sanjay-ec2-eip" {
  instance = aws_instance.sanjay-server.id
}

#ssh keypair code
resource "aws_key_pair" "ltimindtree" {
  key_name   = "ltitestkey"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDRE4i+Rl5U9JGJR94UxdcWcYUaMdi2+1PTBWDNZ2/IZWsf52kbqgmuZdf65274SI7mPH/LNQ5k70DUTREl35dbSeW2E1qeUAOpjyevR/7Nk8mEiwBnqzuYTjJi4TglIcL3FGnkRqZXrHFTQxhIHWIRq1FVsALdB0G8eBA/RsmBR9kFAOzzW9fsmEdi0h1gUx+KhasAnizHr8cuTfj+lTkchHIl0Nh4k8SJrndFxukkAAMbRRy5HTiHjXgyG7DtOdwJEQN7NurrpeaNFKvbyR9Vp9HbOwCG+lKo01LM+imtcdNxZTOoUz5McKQ+HLg9xZNEjNF1ln7WTYG9paVSND/11rE5ZLGHqCTWUYwnhftCMywHEJCBXsswGaYCzBidg/bWciA9Z6MUxkQn+8YV8Z+Kl3gaab++DRYf4jsZOgL5KUFOXXUhCpud8Fgsgjfos6x67FyNVKlNpw0qwU4iWU1p30/ssH6e/V8vYhTnN30CoOMN+fadVJ15VmdsZHgG7hE= root@ip-172-31-12-94.ap-south-1.compute.internal"
}

###this is database ec2 code
resource "aws_instance" "database-server" {
  ami             = "ami-05caa5aa0186b660f"
  subnet_id       = aws_subnet.private-subnet.id
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.test_access.id}"]
  key_name        = "ltitestkey"
  tags = {
    Name     = "db-World"
    Stage    = "stage-base"
    Location = "delhi"
  }

}
##create a public ip for Nat gateway
resource "aws_eip" "nat-eip" {
}
### create Nat gateway
resource "aws_nat_gateway" "my-ngw" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.public-subnet.id
}

#create private route table
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.test-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.my-ngw.id
  }


  tags = {
    Name = "private-rt"
  }
}
##route Tatable assosication code
resource "aws_route_table_association" "private-asso" {
  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.private-rt.id
}

