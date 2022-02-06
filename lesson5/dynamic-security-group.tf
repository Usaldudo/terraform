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

resource "aws_security_group" "my_dynamic-sg" {
  name        = "Dynamic Security Group"
  description = "Dynamic Security Group"

  dynamic "ingress" {
    for_each = ["80", "443", "8080"]
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

  # ingress = [
  #   {
  #     description      = "HTTP"
  #     from_port        = 80
  #     to_port          = 80
  #     protocol         = "tcp"
  #     cidr_blocks      = ["0.0.0.0/0"]
  #     ipv6_cidr_blocks = []
  #     prefix_list_ids  = []
  #     security_groups  = []
  #     self             = false
  #   },
  #   {
  #     description      = "HTTP"
  #     from_port        = 443
  #     to_port          = 443
  #     protocol         = "tcp"
  #     cidr_blocks      = ["0.0.0.0/0"]
  #     ipv6_cidr_blocks = []
  #     prefix_list_ids  = []
  #     security_groups  = []
  #     self             = false
  #   }
  # ]

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
    Name = "dynamic sg"
  }
}
