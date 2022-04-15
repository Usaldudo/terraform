terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws",
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "ca-central-1"
}

terraform {
  backend "s3" {
    bucket = "terraform-test-remote-state-12343"
    key    = "dev/servers/terraform.tfstate"
    region = "ca-central-1"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "terraform-test-remote-state-12343"
    key    = "dev/network/terraform.tfstate"
    region = "ca-central-1"
  }
}

resource "aws_security_group" "webserver" {
  name        = "WebServer SG"
  description = "Allow inbound traffic"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress = [
    {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

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

output "sg_id" {
  value = aws_security_group.webserver.id
}

