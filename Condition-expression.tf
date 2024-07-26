###set Variables with data type

variable  "isprod"  {
    type  = bool
    default = false
    }
#code end here

#create Ec2 instances
resource  "aws_instance" "myec2" {
    count = (var.isprod) ? 2:1
    ami = "ami-068e0f1a600cd311c"
    instance_type = "t2.micro"
      tags  = {
          Name  = "Hello-Terra"
          }
    }

#code end here

NOte: when My production value is true. It will create 2 instances and If Production value is false. It will create 1 Instance
#terraform validate
#terraform plan
# terraform apply
