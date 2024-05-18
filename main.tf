## Data block for VPC and Subnets
data "aws_vpc" "defvpc" {
  default = true
}

data "aws_subnet" "defsubnet1" {
  id = "subnet-0e4f41a1971f7440a"
}

data "aws_subnet" "defsubnet2" {
  id ="subnet-06342b6a67bf808b6"
}
## Security group for alb and webservers
resource "aws_security_group" "albsg" {
  name = "albsg"
  description = "sg for my alb and webservers"
  vpc_id = data.aws_vpc.defvpc.id
  ingress {
    description = "inbound rules for ssh"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    description = "inbound rules for http"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    description = "inbound rules for https"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  egress {
    description = "all outbound rules"
    from_port = 0
    to_port = 0
    protocol = "-1" #means all
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}
#alb configuration

 resource "aws_alb" "alb1" {
  internal = false
  load_balancer_type = "application"
  name = "atlasalb1"
  security_groups = [aws_security_group.albsg.id]
  subnets = [data.aws_subnet.defsubnet1.id,data.aws_subnet.defsubnet2.id]
  depends_on = [ aws_security_group.albsg ]
}

resource "aws_alb_target_group" "tg1" {
  load_balancing_algorithm_type = "round_robin"
  name = "tg1"
  port = 80
  protocol = "HTTP"
  slow_start = 80
  target_type = "instance"
  vpc_id = data.aws_vpc.defvpc.id
  depends_on = [ aws_alb.alb1 ]
}

resource "aws_alb_listener" "alblisten" {
  load_balancer_arn = aws_alb.alb1.arn
  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.tg1.arn
  }
  port = 80
  protocol = "HTTP"
  depends_on = [ aws_alb.alb1,aws_alb_target_group.tg1 ]
}

#Launch template

#asg config