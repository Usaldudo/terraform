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
  region = "eu-north-1"
}

resource "aws_instance" "webserver" {
  ami                                  = "ami-0d15082500b576303" # Amazon linux
  instance_type                        = "t3.micro"
  key_name                             = "pc"
  vpc_security_group_ids               = [aws_security_group.my_webserver.id]
  instance_initiated_shutdown_behavior = "terminate"
  tags = {
    Name = "WebServer"
  }
  depends_on = [
    aws_instance.database,
    aws_instance.app
  ]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "app" {
  ami                                  = "ami-0d15082500b576303" # Amazon linux
  instance_type                        = "t3.micro"
  key_name                             = "pc"
  vpc_security_group_ids               = [aws_security_group.my_webserver.id]
  instance_initiated_shutdown_behavior = "terminate"
  tags = {
    Name = "Application"
  }
  depends_on = [
    aws_instance.database
  ]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "database" {
  ami                                  = "ami-0d15082500b576303" # Amazon linux
  instance_type                        = "t3.micro"
  key_name                             = "pc"
  vpc_security_group_ids               = [aws_security_group.my_webserver.id]
  instance_initiated_shutdown_behavior = "terminate"
  tags = {
    Name = "Database"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "my_webserver" {
  name        = "WebServer Security Group"
  description = "Allow TLS inbound traffic"

  dynamic "ingress" {
    for_each = ["80", "443"]
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

  tags = {
    Name = "my_webserversg"
  }
}
