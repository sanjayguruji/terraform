data "aws_availability_zones" "az" {
  state = "available"
}

# Take out put
output "az" {
  value = data.aws_availability_zones.az.names
}
