# Terraform
#
# Build webserver

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws",
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.*x86_64-gp2"]
  }
}

resource "aws_eip" "my_static_ip" {
  instance = aws_instance.webserver.id
}

resource "aws_instance" "webserver" {
  ami                                  = data.aws_ami.latest_amazon_linux.id
  instance_type                        = var.instance_type
  key_name                             = var.key_name
  vpc_security_group_ids               = [aws_security_group.my_webserver.id]
  instance_initiated_shutdown_behavior = "terminate"
  monitoring                           = var.enable_detailed_monitoring
  tags = merge(var.common_tags, {
    Name = "${var.common_tags["Environment"]} Server IP"
  })
  /*
  tags = {
    Name = "WebServer"
  }
*/
  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_security_group" "my_webserver" {
  name        = "WebServer Security Group"
  description = "Allow TLS inbound traffic"

  dynamic "ingress" {
    for_each = var.allow_ports
    content {
      description      = "HTTP"
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  }


  egress = [
    {
      description      = "HTTP"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
}
