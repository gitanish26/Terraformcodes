resource "aws_elb" "example" {
  name               = "terraform-asg-example"
  security_groups    = ["${aws_security_group.elb-securitygroup.id}"]
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
  #availability_zones = ["${data.aws_availability_zones.available.names[count.index]}"]
health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:80/index.html"
  }
  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 80
    instance_protocol = "http"
  }
  cross_zone_load_balancing = true
  connection_draining = true
  connection_draining_timeout = 400
}
resource "aws_launch_configuration" "example-launchconfig" {
  name_prefix          = "LC created using terraform"
  image_id             = "ami-00068cd7555f543d5"
  instance_type        = "t2.micro"
  #key_name             = "${aws_key_pair.mykeypair.key_name}"
  security_groups      = ["${aws_security_group.myinstance.id}"]
  user_data            = "${file("setup_apache.sh")}"
  lifecycle              { create_before_destroy = true }
}

## Creating AutoScaling Group
resource "aws_autoscaling_group" "example" {
  launch_configuration = "${aws_launch_configuration.example-launchconfig.id}"
 availability_zones   =  ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
 #availability_zones = ["${data.aws_availability_zones.available.names[count.index]}"]
  min_size             = 2
  max_size             = 10
  load_balancers       = ["${aws_elb.example.name}"]
  health_check_type    = "ELB"
  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
  }
}

