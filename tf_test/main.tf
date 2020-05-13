provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  profile = "default"
  region  = "us-east-2"
}

terraform {

  backend "s3" {
    bucket = "tf-phase-of-moon"
    key = "tf-state/terraform.tfstate"
    region = "us-east-2"
}
}

data "template_file" "user_data" {
  template = "${file("${path.module}/epic_script.sh")}"
}

data "aws_availability_zones" "available" {
  state = "available"
}

#data "aws_availability_zones" "all" {}

resource "aws_security_group" "tf-test" {
  name        = "allow-ssh-tf-test"
  ingress {
    description = "ssh inbound"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["77.122.13.241/32"]
  }
  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
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

resource "aws_launch_configuration" "tftest" {
  name = "nginx"
  image_id = "ami-07c1207a9d40bc3bd"
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.tf-test.id}"]
  instance_type = "t2.micro"
  user_data = "${file("epic_script.sh")}"
  }

resource "aws_autoscaling_group" "asg-test" {
  launch_configuration = "${aws_launch_configuration.tftest.id}"
  availability_zones = ["${data.aws_availability_zones.available.names[0]}"]
  desired_capacity = 1
  min_size = 1
  max_size = 3
  load_balancers = ["${aws_elb.test_elb.name}"]
  health_check_type = "ELB"
    tag {
      key = "Name"
      value = "asg-test"
      propagate_at_launch = true
    }
}

resource "aws_elb" "test_elb" {
  name = "tfelbtest"
  security_groups = ["${aws_security_group.tf-test.id}"]
  availability_zones = ["${data.aws_availability_zones.available.names[0]}"]
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:80/"
  }
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = 80
    instance_protocol = "http"
  }
}
