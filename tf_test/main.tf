provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
  access_key = "/home/user/Downloads/Test_AWS.pem"
  secret_key = "/home/user/Downloads/Test_AWS.pem"
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"

  ingress {
    description = "ssh inbound"
    from_port   = 22
    to_port     = 22
    protocol    = "ssh"
    cidr_blocks = ["77.122.13.241/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_launch_template" "tf_test" {
  name = "tf_test"

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 20
    }
  }

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  cpu_options {
    core_count       = 4
    threads_per_core = 2
  }

  credit_specification {
    cpu_credits = "standard"
  }

  disable_api_termination = true

  ebs_optimized = true

  #elastic_gpu_specifications {
  #  type = "test"
  #}

  #elastic_inference_accelerator {
  #  type = "eia1.medium"
  #}

  image_id = "ami-07c1207a9d40bc3bd"

  instance_initiated_shutdown_behavior = "terminate"

  security_group_names {
    name="allow_ssh"
  }
  #instance_market_options {
  #  market_type = "spot"
  #}

  instance_type = "t2.micro"

  key_name = "Test_AWS"

  license_specification {
    license_configuration_arn = "arn:aws:license-manager:eu-west-1:123456789012:license-configuration:lic-0123456789abcdef0123456789abcdef"
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = true
  }

  placement {
    availability_zone = "us-west-2a"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "test_inst"
    }
  }

  user_data = filebase64("${path.module}/epic_scri.sh")
}
