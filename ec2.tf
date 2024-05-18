resource "aws_instance" "admin0" {
    availability_zone = "us-east-1"
    instance_type = "t2.micro"
    ami = "ami-0bb84b8ffd87024d8"
    tags = {
      "Name" = "admin0"
    }
}