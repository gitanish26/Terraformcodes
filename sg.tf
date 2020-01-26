resource "aws_security_group" "elb-securitygroup" {
name = "terraform-example-elb"
egress {
from_port   = 0
to_port     = 0
protocol    = "-1"
cidr_blocks = ["0.0.0.0/0"]
}
ingress {
from_port   = 80
to_port     = 80
protocol    = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
}
#launch config security group
resource "aws_security_group" "myinstance" {
name = "launchconfiginstancesg"
description = "security group for my instance"
egress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}

ingress {
from_port = 22
to_port = 22
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
ingress {
from_port = 80
to_port = 80
protocol = "tcp"
security_groups = ["${aws_security_group.elb-securitygroup.id}"]
}
}
